//
//  MovieDetailsCoordinator.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import SwiftUI
import UIKit

@MainActor
final class MovieDetailsCoordinator {
  private let navigationController: UINavigationController
  private let movieCatalog: MockMovieCataloging

  init(
    navigationController: UINavigationController,
    movieCatalog: MockMovieCataloging
  ) {
    self.navigationController = navigationController
    self.movieCatalog = movieCatalog
  }

  func showMovieDetails(for movieID: Int, animated: Bool) {
    let details = movieCatalog.details(for: movieID) ?? fallbackMovieDetails(for: movieID)
    let detailsView = MovieDetailsMockView(movieDetails: details)
    let hostingController = UIHostingController(rootView: detailsView)
    hostingController.title = details.title
    hostingController.navigationItem.largeTitleDisplayMode = .never

    navigationController.pushViewController(hostingController, animated: animated)
  }

  private func fallbackMovieDetails(for movieID: Int) -> MovieDetails {
    MovieDetails(
      id: movieID,
      title: "Unknown Movie",
      overview: "No mocked details are available for this movie id yet.",
      posterPath: nil,
      releaseDate: nil,
      rating: 0
    )
  }
}
