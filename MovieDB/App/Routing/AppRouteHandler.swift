//
//  AppRouteHandler.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import UIKit

@MainActor
protocol AppRouteHandling {
  func route(for url: URL) -> AppRoute?
}

@MainActor
struct AppRouteHandler: AppRouteHandling {
  let parser: DeepLinkParsing

  func route(for url: URL) -> AppRoute? {
    parser.parse(url: url)
  }
}
