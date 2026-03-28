//
//  MoviesListPlaceholderViewController.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import UIKit

final class MoviesListPlaceholderViewController: UIViewController {
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Popular Movies"
    navigationItem.largeTitleDisplayMode = .always
    view.backgroundColor = .white

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .preferredFont(forTextStyle: .title2)
    titleLabel.text = "MoviesListPlaceholderViewController"
    titleLabel.numberOfLines = 0

    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.font = .preferredFont(forTextStyle: .body)
    descriptionLabel.textColor = .secondaryLabel
    descriptionLabel.numberOfLines = 0
    descriptionLabel.text = "List movies here."

    view.addSubview(titleLabel)
    view.addSubview(descriptionLabel)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
    ])
  }
}
