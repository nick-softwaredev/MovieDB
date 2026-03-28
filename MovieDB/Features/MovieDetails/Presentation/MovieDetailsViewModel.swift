//
//  MovieDetailsViewModel.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Combine
import Foundation

@MainActor
final class MovieDetailsViewModel: MovieDetailsViewModeling {
  let movieID: Int
  private let repository: MovieDetailsRepository

  @Published private(set) var state: MovieDetailsScreenState = .idle

  init(
    movieID: Int,
    repository: MovieDetailsRepository
  ) {
    self.movieID = movieID
    self.repository = repository
  }

  func onAppear() async {
    guard case .idle = state else { return }
    await loadMovieDetails()
  }

  func retry() async {
    await loadMovieDetails()
  }

  private func loadMovieDetails() async {
    state = .loading

    do {
      let details = try await repository.fetchMovieDetails(for: movieID)
      state = .loaded(details)
    } catch let error as AppError {
      state = error == .networkUnavailable ? .noNetworkConnection : .failed(error)
    } catch {
      state = .failed(.unknown(message: error.localizedDescription))
    }
  }
}
