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

extension AppError {
  var userMessage: String {
    switch self {
    case .networkUnavailable:
      return "The network is unavailable right now. Please try again."
    case .invalidResponse:
      return "The response was invalid. Please try again."
    case .decodingFailed:
      return "The response could not be decoded. Please try again."
    case .invalidRequest:
      return "The request could not be created. Please try again."
    case .invalidDeepLink:
      return "The incoming deep link is invalid."
    case let .missingConfiguration(key):
      return "Missing configuration value: \(key)."
    case let .unknown(message):
      return message
    }
  }
}
