//
//  AppError.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation

enum AppError: Error, Equatable {
  case networkUnavailable
  case invalidResponse
  case decodingFailed
  case invalidRequest
  case invalidDeepLink
  case missingConfiguration(key: String)
  case unknown(message: String)
}
