//
//  MovieSummary.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation

struct MovieSummary: Equatable, Identifiable {
  let id: Int
  let title: String
  let posterPath: String?
}
