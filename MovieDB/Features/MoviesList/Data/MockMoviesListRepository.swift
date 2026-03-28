//
//  MockMoviesListRepository.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Foundation

enum MockMoviesListRepositoryMode {
  case success
  case failure(AppError)
}

struct MockMoviesListRepository: MoviesListRepository {
  let movieCatalog: MockMovieCataloging
  let mode: MockMoviesListRepositoryMode
  let pageSize: Int

  init(
    movieCatalog: MockMovieCataloging,
    mode: MockMoviesListRepositoryMode = .success,
    pageSize: Int = 10
  ) {
    self.movieCatalog = movieCatalog
    self.mode = mode
    self.pageSize = pageSize
  }

  func fetchPopularMovies(page: Int) async throws -> [MovieSummary] {
    // simulate network delay
    try await Task.sleep(for: .milliseconds(700))

    switch mode {
    case .success:
      let startIndex = max(0, (page - 1) * pageSize)
      guard startIndex < movieCatalog.popularMovies.count else {
        return []
      }

      let endIndex = min(startIndex + pageSize, movieCatalog.popularMovies.count)
      return Array(movieCatalog.popularMovies[startIndex..<endIndex])
    case let .failure(error):
      throw error
    }
  }
}
