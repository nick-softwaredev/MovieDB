//
//  MoviesListTableViewCell.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import UIKit

final class MoviesListTableViewCell: UITableViewCell {
  static let reuseIdentifier = "MoviesListTableViewCell"

  private let cardView = UIView()
  private let posterView = UIImageView()
  private let posterLoadingIndicator = UIActivityIndicatorView(style: .medium)
  private let titleLabel = UILabel()
  private let chevronView = UIImageView(image: UIImage(systemName: "chevron.right"))
  private var imageLoadTask: Task<Void, Never>?
  private var representedPosterURL: URL?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear

    configureCardView()
    configurePosterView()
    configureLabels()
    configureChevron()
    setUpLayout()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageLoadTask?.cancel()
    imageLoadTask = nil
    representedPosterURL = nil
    showPosterPlaceholder(isLoading: false)
  }

  func configure(with movie: MovieSummary, posterURL: URL?, imageLoader: ImageLoading) {
    titleLabel.text = movie.title
    representedPosterURL = posterURL
    showPosterPlaceholder(isLoading: posterURL != nil)

    guard let posterURL else { return }

    imageLoadTask?.cancel()
    imageLoadTask = Task { [weak self] in
      guard let self else { return }

      do {
        let image = try await imageLoader.loadImage(from: posterURL)
        guard !Task.isCancelled, representedPosterURL == posterURL else { return }
        posterView.image = image
        posterLoadingIndicator.stopAnimating()
      } catch {
        guard !Task.isCancelled else { return }
        showPosterPlaceholder(isLoading: false)
      }
    }
  }

  private func configureCardView() {
    cardView.translatesAutoresizingMaskIntoConstraints = false
    cardView.backgroundColor = .secondarySystemBackground
    cardView.layer.cornerRadius = 20
    cardView.layer.cornerCurve = .continuous
    contentView.addSubview(cardView)
  }

  private func configurePosterView() {
    posterView.translatesAutoresizingMaskIntoConstraints = false
    posterView.backgroundColor = .tertiarySystemFill
    posterView.image = UIImage(systemName: "film.fill")
    posterView.tintColor = .secondaryLabel
    posterView.contentMode = .scaleAspectFit
    posterView.layer.cornerRadius = 14
    posterView.layer.cornerCurve = .continuous
    posterView.clipsToBounds = true
    cardView.addSubview(posterView)

    posterLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    posterLoadingIndicator.hidesWhenStopped = true
    cardView.addSubview(posterLoadingIndicator)
  }

  private func configureLabels() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.numberOfLines = 2

    cardView.addSubview(titleLabel)
  }

  private func configureChevron() {
    chevronView.translatesAutoresizingMaskIntoConstraints = false
    chevronView.tintColor = .tertiaryLabel
    chevronView.contentMode = .scaleAspectFit
    cardView.addSubview(chevronView)
  }

  private func setUpLayout() {
    NSLayoutConstraint.activate([
      cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      cardView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      cardView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

      posterView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
      posterView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
      posterView.widthAnchor.constraint(equalToConstant: 64),
      posterView.heightAnchor.constraint(equalToConstant: 88),

      posterLoadingIndicator.centerXAnchor.constraint(equalTo: posterView.centerXAnchor),
      posterLoadingIndicator.centerYAnchor.constraint(equalTo: posterView.centerYAnchor),

      chevronView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
      chevronView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
      chevronView.widthAnchor.constraint(equalToConstant: 10),

      titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -12)
    ])
  }

  private func showPosterPlaceholder(isLoading: Bool) {
    posterView.image = UIImage(systemName: "film.fill")
    if isLoading {
      posterLoadingIndicator.startAnimating()
    } else {
      posterLoadingIndicator.stopAnimating()
    }
  }
}
