//
//  MovieDetails.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation

struct MovieDetails: Equatable {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String?
  let releaseDate: Date?
  let rating: Double
}
