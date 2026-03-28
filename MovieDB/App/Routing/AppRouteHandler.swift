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

  func handle(url: URL, from navigationController: UINavigationController) {
    guard let route = parser.parse(url: url) else { return }

    let message: String

    switch route {
    case let .movieDetails(movieID):
      message = "Resolved deep link for movie id \(movieID). Details flow is wired in the next step."
    }

    let alert = UIAlertController(
      title: "Deep Link Received",
      message: message,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))

    let presenter = navigationController.presentedViewController ?? navigationController
    presenter.present(alert, animated: true)
  }
}
