//
//  AppCoordinator.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import UIKit

@MainActor
final class AppCoordinator {
  private let window: UIWindow
  private let navigationController: UINavigationController
  private let routeHandler: AppRouteHandling
  private let moviesListCoordinator: MoviesListCoordinator
  private let movieDetailsCoordinator: MovieDetailsCoordinator

  init(
    window: UIWindow,
    navigationController: UINavigationController,
    routeHandler: AppRouteHandling,
    moviesListCoordinator: MoviesListCoordinator,
    movieDetailsCoordinator: MovieDetailsCoordinator
  ) {
    self.window = window
    self.navigationController = navigationController
    self.routeHandler = routeHandler
    self.moviesListCoordinator = moviesListCoordinator
    self.movieDetailsCoordinator = movieDetailsCoordinator
  }

  func start() {
    let rootViewController = moviesListCoordinator.start { [weak self] route in
      self?.handle(route: route)
    }

    navigationController.setViewControllers([rootViewController], animated: false)

    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }

  func handle(url: URL) {
    guard let route = routeHandler.route(for: url) else { return }
    handle(route: route)
  }

  private func handle(route: AppRoute) {
    switch route {
    case let .movieDetails(movieID):
      showMovieDetails(for: movieID, animated: true)
    }
  }

  private func showMovieDetails(for movieID: Int, animated: Bool) {
    movieDetailsCoordinator.showMovieDetails(for: movieID, animated: animated)
  }
}
