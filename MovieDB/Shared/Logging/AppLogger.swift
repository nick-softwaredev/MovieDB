//
//  AppLogger.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Foundation

enum AppLogger {
  static func info(_ message: String, category: String) {
    print("[INFO \(icon(for: category))][\(category)] \(message)")
  }

  static func error(_ message: String, category: String) {
    print("[ERROR \(icon(for: category))][\(category)] \(message)")
  }

  private static func icon(for category: String) -> String {
    switch category {
    case "ImageLoader":
      return "🖼️"
    case "Network":
      return "🌐"
    case "Pagination":
      return "📄"
    case "MovieDetails":
      return "🎬"
    default:
      return "ℹ️"
    }
  }
}
