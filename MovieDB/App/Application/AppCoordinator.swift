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

  init(
    window: UIWindow,
    navigationController: UINavigationController,
    routeHandler: AppRouteHandling
  ) {
    self.window = window
    self.navigationController = navigationController
    self.routeHandler = routeHandler
  }

  func start() {
    let rootViewController = MoviesListPlaceholderViewController()
    navigationController.setViewControllers([rootViewController], animated: false)

    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }

  func handle(url: URL) {
    routeHandler.handle(url: url, from: navigationController)
  }
}
