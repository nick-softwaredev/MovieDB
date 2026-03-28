//
//  AppDependencies.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import UIKit

@MainActor
struct AppDependencies {
  let configuration: AppConfiguration
  let routeHandler: AppRouteHandling

  static func live() -> AppDependencies {
    let configuration = AppConfiguration.load()
    let routeHandler = AppRouteHandler(parser: DeepLinkParser())

    return AppDependencies(
      configuration: configuration,
      routeHandler: routeHandler
    )
  }

  func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
    let navigationController = UINavigationController()
    navigationController.navigationBar.prefersLargeTitles = true

    return AppCoordinator(
      window: window,
      navigationController: navigationController,
      routeHandler: routeHandler
    )
  }
}
