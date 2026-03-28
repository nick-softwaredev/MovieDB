//
//  MoviesListRepository.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

protocol MoviesListRepository {
  func fetchPopularMovies(page: Int) async throws -> [MovieSummary]
}
