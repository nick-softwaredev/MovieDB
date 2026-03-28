//
//  APIEndpoint.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation

protocol APIEndpoint {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var queryItems: [URLQueryItem] { get }
  var headers: [String: String] { get }
}
