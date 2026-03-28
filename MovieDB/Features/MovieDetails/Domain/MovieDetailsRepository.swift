//
//  MovieDetailsRepository.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

protocol MovieDetailsRepository {
  func fetchMovieDetails(for movieID: Int) async throws -> MovieDetails
}
