//
//  MockMovieDetailsRepository.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

struct MockMovieDetailsRepository: MovieDetailsRepository {
  let movieCatalog: MockMovieCataloging

  func fetchMovieDetails(for movieID: Int) async throws -> MovieDetails {
    try await Task.sleep(for: .milliseconds(500))

    guard let details = movieCatalog.details(for: movieID) else {
      throw AppError.invalidResponse
    }

    return details
  }
}
