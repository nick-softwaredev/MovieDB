//
//  MoviesListViewController.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import UIKit

@MainActor
final class MoviesListViewController: UIViewController {
  private let viewModel: MoviesListViewModeling
  private let imageLoader: ImageLoading
  private let posterURLBuilder: PosterURLBuilding
  private let onRouteRequested: (AppRoute) -> Void

  private let tableView = UITableView(frame: .zero, style: .plain)
  private let refreshControl = UIRefreshControl()
  private let loadingView = UIActivityIndicatorView(style: .large)
  private let errorStackView = UIStackView()
  private let errorTitleLabel = UILabel()
  private let errorMessageLabel = UILabel()
  private let retryButton = UIButton(type: .system)
  private var refreshMinimumEndTime: Date?

  init(
    viewModel: MoviesListViewModeling,
    imageLoader: ImageLoading,
    posterURLBuilder: PosterURLBuilding,
    onRouteRequested: @escaping (AppRoute) -> Void
  ) {
    self.viewModel = viewModel
    self.imageLoader = imageLoader
    self.posterURLBuilder = posterURLBuilder
    self.onRouteRequested = onRouteRequested
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Popular Movies"
    navigationItem.largeTitleDisplayMode = .always
    view.backgroundColor = .systemBackground

    configureTableView()
    configureLoadingView()
    configureErrorView()
    bindViewModel()

    Task { await viewModel.onViewDidLoad() }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  private func bindViewModel() {
    viewModel.onStateChange = { [weak self] state in
      self?.render(state)
    }

    render(viewModel.state)
  }

  private func render(_ state: MoviesListScreenState) {
    switch state {
    case .idle, .loading:
      showLoading()
    case .loaded:
      showContent()
    case .noNetworkConnection:
      showError(message: "No internet connection. Please check your network and try again.")
    case let .failed(error):
      showError(message: error.userMessage)
    }
  }

  private func configureTableView() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .systemBackground
    tableView.separatorStyle = .none
    tableView.rowHeight = 124
    tableView.showsVerticalScrollIndicator = false
    tableView.contentInsetAdjustmentBehavior = .automatic
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
    refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
    tableView.refreshControl = refreshControl
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(MoviesListTableViewCell.self, forCellReuseIdentifier: MoviesListTableViewCell.reuseIdentifier)

    view.addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  private func configureLoadingView() {
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    loadingView.hidesWhenStopped = true
    view.addSubview(loadingView)

    NSLayoutConstraint.activate([
      loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  private func configureErrorView() {
    errorStackView.translatesAutoresizingMaskIntoConstraints = false
    errorStackView.axis = .vertical
    errorStackView.spacing = 12
    errorStackView.alignment = .center
    errorStackView.isHidden = true

    errorTitleLabel.font = .preferredFont(forTextStyle: .title3)
    errorTitleLabel.text = "Couldn’t load movies"

    errorMessageLabel.font = .preferredFont(forTextStyle: .body)
    errorMessageLabel.textColor = .secondaryLabel
    errorMessageLabel.numberOfLines = 0
    errorMessageLabel.textAlignment = .center

    retryButton.configuration = .filled()
    retryButton.configuration?.title = "Retry"
    retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

    errorStackView.addArrangedSubview(errorTitleLabel)
    errorStackView.addArrangedSubview(errorMessageLabel)
    errorStackView.addArrangedSubview(retryButton)
    view.addSubview(errorStackView)

    NSLayoutConstraint.activate([
      errorStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      errorStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      errorStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
      errorStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor)
    ])
  }

  private func showLoading() {
    loadingView.startAnimating()
    endRefreshingIfNeeded()
    tableView.isHidden = true
    errorStackView.isHidden = true
  }

  private func showContent() {
    loadingView.stopAnimating()
    endRefreshingIfNeeded()
    errorStackView.isHidden = true
    tableView.isHidden = false
    tableView.reloadData()
  }

  private func showError(message: String) {
    loadingView.stopAnimating()
    endRefreshingIfNeeded()
    errorMessageLabel.text = message
    tableView.isHidden = true
    errorStackView.isHidden = false
  }

  @objc
  private func retryTapped() {
    Task {
      await viewModel.retry()
    }
  }

  @objc
  private func refreshTriggered() {
    refreshMinimumEndTime = Date().addingTimeInterval(0.5)
    Task {
      await viewModel.retry()
    }
  }

  private func endRefreshingIfNeeded() {
    guard refreshControl.isRefreshing else { return }

    if let refreshMinimumEndTime, refreshMinimumEndTime > Date() {
      let delay = refreshMinimumEndTime.timeIntervalSinceNow
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
        guard let self else { return }
        self.refreshControl.endRefreshing()
        self.refreshMinimumEndTime = nil
      }
      return
    }

    refreshControl.endRefreshing()
    refreshMinimumEndTime = nil
  }
}

extension MoviesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.moviesCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: MoviesListTableViewCell.reuseIdentifier,
        for: indexPath
      ) as? MoviesListTableViewCell,
      let movie = viewModel.movie(at: indexPath.row)
    else {
      return UITableViewCell()
    }

    let posterURL = posterURLBuilder.makePosterURL(path: movie.posterPath)
    cell.configure(with: movie, posterURL: posterURL, imageLoader: imageLoader)
    return cell
  }
}

extension MoviesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    guard let route = viewModel.didSelectMovie(at: indexPath.row) else { return }
    onRouteRequested(route)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    Task {
      await viewModel.loadNextPageIfNeeded(currentIndex: indexPath.row)
    }
  }
}
