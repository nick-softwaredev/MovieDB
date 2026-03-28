//
//  TMDBMovieEndpoint.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Foundation

enum TMDBMovieEndpoint: APIEndpoint {
  case popular(configuration: AppConfiguration, page: Int)
  case details(configuration: AppConfiguration, movieID: Int)

  var baseURL: URL {
    switch self {
    case let .popular(configuration, _), let .details(configuration, _):
      return configuration.tmdbAPIBaseURL
    }
  }

  var path: String {
    switch self {
    case .popular:
      return "movie/popular"
    case let .details(_, movieID):
      return "movie/\(movieID)"
    }
  }

  var method: HTTPMethod {
    .get
  }

  var queryItems: [URLQueryItem] {
    switch self {
    case let .popular(_, page):
      return [
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "page", value: String(page))
      ]
    case .details:
      return [
        URLQueryItem(name: "language", value: "en-US")
      ]
    }
  }

  var headers: [String : String] {
    switch self {
    case let .popular(configuration, _), let .details(configuration, _):
      return [
        "accept": "application/json",
        "Authorization": "Bearer \(configuration.tmdbReadAccessToken)"
      ]
    }
  }
}
