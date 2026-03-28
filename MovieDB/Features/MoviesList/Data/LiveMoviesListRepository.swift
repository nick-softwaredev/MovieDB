//
//  LiveMoviesListRepository.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Foundation

struct LiveMoviesListRepository: MoviesListRepository {
  let networkClient: NetworkClient
  let configuration: AppConfiguration

  func fetchPopularMovies(page: Int) async throws -> [MovieSummary] {
    let endpoint = TMDBMovieEndpoint.popular(configuration: configuration, page: page)
    let response: PopularMoviesResponseDTO = try await networkClient.send(endpoint)

    return response.results.map { dto in
      MovieSummary(
        id: dto.id,
        title: dto.title,
        posterPath: dto.posterPath
      )
    }
  }
}
