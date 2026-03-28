//
//  MovieDetailsDTO.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation

struct MovieDetailsDTO: Decodable, Equatable {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String?
  let releaseDate: String?
  let voteAverage: Double

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case overview
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case voteAverage = "vote_average"
  }
}
