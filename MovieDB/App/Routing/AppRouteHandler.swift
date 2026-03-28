//
//  AppRouteHandler.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import UIKit

@MainActor
protocol AppRouteHandling {
  func handle(url: URL, from navigationController: UINavigationController)
}

@MainActor
struct AppRouteHandler: AppRouteHandling {
  let parser: DeepLinkParsing

    let presenter = navigationController.presentedViewController ?? navigationController
    presenter.present(alert, animated: true)
  }
}
