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
  private let repository: MovieDetailsRepository
  private let imageLoader: ImageLoading
  private let posterURLBuilder: PosterURLBuilding

  init(
    navigationController: UINavigationController,
    repository: MovieDetailsRepository,
    imageLoader: ImageLoading,
    posterURLBuilder: PosterURLBuilding
  ) {
    self.navigationController = navigationController
    self.repository = repository
    self.imageLoader = imageLoader
    self.posterURLBuilder = posterURLBuilder
  }

  func showMovieDetails(for movieID: Int, animated: Bool) {
    let viewModel = MovieDetailsViewModel(
      movieID: movieID,
      repository: repository
    )
    let detailsView = MovieDetailsView(
      viewModel: viewModel,
      imageLoader: imageLoader,
      posterURLBuilder: posterURLBuilder
    )
    let hostingController = UIHostingController(rootView: detailsView)
    hostingController.title = "Movie Details"
    hostingController.navigationItem.largeTitleDisplayMode = .never

    navigationController.pushViewController(hostingController, animated: animated)
  }
}
