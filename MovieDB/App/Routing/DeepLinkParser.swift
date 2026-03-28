//
//  DeepLinkParser.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation

protocol DeepLinkParsing {
  func parse(url: URL) -> AppRoute?
}

struct DeepLinkParser: DeepLinkParsing {
  func parse(url: URL) -> AppRoute? {
    guard url.scheme == "movieapp" else { return nil }

    let host = url.host?.lowercased()
    let pathComponents = url.pathComponents.filter { $0 != "/" }

    if host == "moviedetails", let movieID = Int(pathComponents.first ?? "") {
      return .movieDetails(movieID: movieID)
    }

    return nil
  }
}
