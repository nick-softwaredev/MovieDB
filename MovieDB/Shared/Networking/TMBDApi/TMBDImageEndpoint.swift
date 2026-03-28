//
//  TMBDImageEndpoint.swift
//  MovieDB
//
//  Created by Nick Todorashko on 2026-03-28.
//

import Foundation

protocol PosterURLBuilding {
  func makePosterURL(path: String?) -> URL?
}

struct TMDBPosterURLBuilder: PosterURLBuilding {
  private let imageBaseURL: URL

  init(imageBaseURL: URL) {
    self.imageBaseURL = imageBaseURL
  }

  func makePosterURL(path: String?) -> URL? {
    guard let path, !path.isEmpty else { return nil }
    return imageBaseURL.appending(path: "t/p/w342").appending(path: path)
  }
}

struct ImageEndpoint: APIEndpoint {
  let baseURL: URL
  let path: String
  let method: HTTPMethod = .get
  let queryItems: [URLQueryItem] = []
  let headers: [String: String] = [:]

  init(url: URL) {
    baseURL = URL(string: "\(url.scheme ?? "https")://\(url.host ?? "")") ?? url
    path = url.path
  }
}
