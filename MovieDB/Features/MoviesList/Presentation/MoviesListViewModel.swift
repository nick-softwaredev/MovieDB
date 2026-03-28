//
//  MoviesListViewModel.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Foundation

@MainActor
final class MoviesListViewModel: MoviesListViewModeling {
  private let repository: MoviesListRepository
  private var movies: [MovieSummary] = []
  private var paginator = MoviesListPaginator()

  private(set) var state: MoviesListScreenState = .idle {
    didSet {
      onStateChange?(state)
    }
  }

  var onStateChange: ((MoviesListScreenState) -> Void)?

  init(repository: MoviesListRepository) {
    self.repository = repository
  }

  var moviesCount: Int {
    return movies.count
  }

  func movie(at index: Int) -> MovieSummary? {
    guard movies.indices.contains(index) else {
      return nil
    }
    return movies[index]
  }

  func onViewDidLoad() async {
    guard movies.isEmpty else { return }
    await loadMovies(reset: true)
  }

  func retry() async {
    await loadMovies(reset: true)
  }

  func loadNextPageIfNeeded(currentIndex: Int) async {
    guard currentIndex == movies.count - 1 else { return }
    await loadMovies(reset: false)
  }

  func didSelectMovie(at index: Int) -> AppRoute? {
    guard let movie = movie(at: index) else {
      return nil
    }
    return .movieDetails(movieID: movie.id)
  }

  private func loadMovies(reset: Bool) async {
    if reset {
      paginator.reset()
      movies = []
      state = .loading
    }

    guard let nextPage = paginator.startLoadingNextPage() else { return }
    AppLogger.info("Loading movies page \(nextPage)", category: "Pagination")

    do {
      let newMovies = try await repository.fetchPopularMovies(page: nextPage)

      paginator.finishLoading(receivedItemCount: newMovies.count, loadedPage: nextPage)
      movies.append(contentsOf: newMovies)
      AppLogger.info("Loaded movies page \(nextPage) with \(newMovies.count) items", category: "Pagination")
      state = .loaded(movies)
    } catch let error as AppError {
      paginator.finishLoadingAfterError()
      AppLogger.error("Failed to load movies page \(nextPage): \(error.userMessage)", category: "Pagination")
      if error == .networkUnavailable {
        state = .noNetworkConnection
      } else if movies.isEmpty {
        state = .failed(error)
      } else {
        state = .loaded(movies)
      }
    } catch {
      paginator.finishLoadingAfterError()
      let appError = AppError.unknown(message: error.localizedDescription)
      AppLogger.error("Failed to load movies page \(nextPage): \(appError.userMessage)", category: "Pagination")
      if movies.isEmpty {
        state = .failed(appError)
      } else {
        state = .loaded(movies)
      }
    }
  }
}
