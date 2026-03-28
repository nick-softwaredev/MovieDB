//
//  MoviesListDTO.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation
// TODO: veerify after getting api key. 
struct PopularMoviesResponseDTO: Decodable, Equatable {
  let results: [MovieSummaryDTO]
}

struct MovieSummaryDTO: Decodable, Equatable {
  let id: Int
  let title: String
  let posterPath: String?

  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case posterPath = "poster_path"
  }
}
