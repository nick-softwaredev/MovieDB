//
//  AppMode.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Foundation

enum AppMode: String {
  case live
  case mock

  static func current(processInfo: ProcessInfo = .processInfo) -> AppMode {
    guard
      let value = processInfo.environment["APP_MODE"],
      let mode = AppMode(rawValue: value.lowercased())
    else {
      return .live
    }

    return mode
  }
}
