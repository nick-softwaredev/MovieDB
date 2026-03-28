//
//  AppDependencies.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import UIKit

@MainActor
struct AppDependencies {
  let configuration: AppConfiguration
  let routeHandler: AppRouteHandling
  let movieCatalog: MockMovieCataloging
  let networkClient: NetworkClient
  let imageLoader: ImageLoading
  let posterURLBuilder: PosterURLBuilding

  static func live() -> AppDependencies {
    let configuration = AppConfiguration.load()
    let routeHandler = AppRouteHandler(parser: DeepLinkParser())
    let movieCatalog = MockMovieCatalog()
    let networkClient = URLSessionNetworkClient()
    let imageLoader = DefaultImageLoader(networkClient: networkClient)
    let posterURLBuilder = TMDBPosterURLBuilder(imageBaseURL: configuration.tmdbImageBaseURL)

    return AppDependencies(
      configuration: configuration,
      routeHandler: routeHandler,
      movieCatalog: movieCatalog,
      networkClient: networkClient,
      imageLoader: imageLoader,
      posterURLBuilder: posterURLBuilder
    )
  }

  static func mock() -> AppDependencies {
    let configuration = AppConfiguration.load()
    let routeHandler = AppRouteHandler(parser: DeepLinkParser())
    let movieCatalog = MockMovieCatalog()
    let networkClient = URLSessionNetworkClient()

    let mockPosterURLPairs: [(String, URL)] = movieCatalog.popularMovies.compactMap { movie in
      guard
        let posterPath = movie.posterPath,
        let url = URL(string: "mock-image://\(movie.id)")
      else {
        return nil
      }

      return (posterPath, url)
    }
    let mockPosterURLs = Dictionary(uniqueKeysWithValues: mockPosterURLPairs)

    let mockImagePairs: [(URL, UIImage)] = mockPosterURLs.values.map { url in
      (url, UIImage(systemName: "photo.fill") ?? UIImage())
    }
    let mockImages = Dictionary(uniqueKeysWithValues: mockImagePairs)

    let imageLoader = MockImageLoader(imagesByURL: mockImages)
    let posterURLBuilder = MockPosterURLBuilder(urlsByPath: mockPosterURLs)

    return AppDependencies(
      configuration: configuration,
      routeHandler: routeHandler,
      movieCatalog: movieCatalog,
      networkClient: networkClient,
      imageLoader: imageLoader,
      posterURLBuilder: posterURLBuilder
    )
  }

  func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
    let navigationController = UINavigationController()
    navigationController.navigationBar.prefersLargeTitles = true
    let moviesListRepository = MockMoviesListRepository(movieCatalog: movieCatalog)
    let moviesListCoordinator = MoviesListCoordinator(
      repository: moviesListRepository,
      imageLoader: imageLoader,
      posterURLBuilder: posterURLBuilder,
      navigationController: navigationController
    )
    let movieDetailsRepository = MockMovieDetailsRepository(movieCatalog: movieCatalog)
    let movieDetailsCoordinator = MovieDetailsCoordinator(
      navigationController: navigationController,
      repository: movieDetailsRepository,
      imageLoader: imageLoader,
      posterURLBuilder: posterURLBuilder
    )

    return AppCoordinator(
      window: window,
      navigationController: navigationController,
      routeHandler: routeHandler,
      moviesListCoordinator: moviesListCoordinator,
      movieDetailsCoordinator: movieDetailsCoordinator
    )
  }
}
