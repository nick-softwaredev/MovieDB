//
//  AppConfiguration.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation

struct AppConfiguration {
  let tmdbAPIKey: String
  let tmdbReadAccessToken: String
  let tmdbAPIBaseURL: URL
  let tmdbImageBaseURL: URL

  static func load(from bundle: Bundle = .main) -> AppConfiguration {
    let apiKey = bundle.object(forInfoDictionaryKey: "TMDBAPIKey") as? String ?? ""
    let readAccessToken = bundle.object(forInfoDictionaryKey: "TMDBReadAccessToken") as? String ?? ""
   
    return AppConfiguration(
      tmdbAPIKey: apiKey,
      tmdbReadAccessToken: readAccessToken,
      tmdbAPIBaseURL: URL(string: "https://api.themoviedb.org/3")!,
      tmdbImageBaseURL: URL(string: "https://image.tmdb.org")!
    )
  }
}
