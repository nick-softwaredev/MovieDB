//
//  MoviesListCoordinator.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import UIKit

@MainActor
final class MoviesListCoordinator {
  private let repository: MoviesListRepository
  private let imageLoader: ImageLoading
  private let posterURLBuilder: PosterURLBuilding
  private let navigationController: UINavigationController

  init(
    repository: MoviesListRepository,
    imageLoader: ImageLoading,
    posterURLBuilder: PosterURLBuilding,
    navigationController: UINavigationController
  ) {
    self.repository = repository
    self.imageLoader = imageLoader
    self.posterURLBuilder = posterURLBuilder
    self.navigationController = navigationController
  }

  func start(onRouteRequested: @escaping (AppRoute) -> Void) -> UIViewController {
    let viewModel = MoviesListViewModel(repository: repository)

    return MoviesListViewController(
      viewModel: viewModel,
      imageLoader: imageLoader,
      posterURLBuilder: posterURLBuilder,
      onRouteRequested: onRouteRequested
    )
  }
}
