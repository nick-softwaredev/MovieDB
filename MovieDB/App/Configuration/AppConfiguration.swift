//
//  AppConfiguration.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation

struct AppConfiguration {
  let tmdbAPIKey: String

  static func load(from bundle: Bundle = .main) -> AppConfiguration {
    let apiKey = bundle.object(forInfoDictionaryKey: "TMDBAPIKey") as? String ?? ""
    return AppConfiguration(tmdbAPIKey: apiKey)
  }
}
