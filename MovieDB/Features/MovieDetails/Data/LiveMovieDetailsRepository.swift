//
//  LiveMovieDetailsRepository.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Foundation

struct LiveMovieDetailsRepository: MovieDetailsRepository {
  let networkClient: NetworkClient
  let configuration: AppConfiguration

  func fetchMovieDetails(for movieID: Int) async throws -> MovieDetails {
    AppLogger.info("Loading movie details for id \(movieID)", category: "MovieDetails")
    let endpoint = TMDBMovieEndpoint.details(configuration: configuration, movieID: movieID)
    let dto: MovieDetailsDTO = try await networkClient.send(endpoint)
    AppLogger.info("Loaded movie details for id \(movieID)", category: "MovieDetails")

    return MovieDetails(
      id: dto.id,
      title: dto.title,
      overview: dto.overview,
      posterPath: dto.posterPath,
      releaseDate: dto.releaseDate.flatMap(Self.releaseDateFormatter.date(from:)),
      rating: dto.voteAverage
    )
  }

  private static let releaseDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}
