import Foundation
import Testing
@testable import MovieDB

@MainActor
struct MovieDetailsRepositoryTests {
  @Test
  func fetchMovieDetailsReturnsCatalogDetails() async throws {
    let repository = MockMovieDetailsRepository(movieCatalog: MockMovieCatalog())

    let details = try await repository.fetchMovieDetails(for: 603)

    #expect(details.id == 603)
    #expect(details.title == "The Matrix")
  }

  @Test
  func fetchMovieDetailsThrowsForUnknownMovie() async {
    let repository = MockMovieDetailsRepository(movieCatalog: MockMovieCatalog())

    await #expect(throws: AppError.invalidResponse) {
      try await repository.fetchMovieDetails(for: -1)
    }
  }
}

@MainActor
struct MovieDetailsViewModelTests {
  @Test
  func onAppearLoadsMovieDetails() async {
    let repository = MovieDetailsRepositorySpy(
      result: .success(
        MovieDetails(
          id: 603,
          title: "The Matrix",
          overview: "Overview",
          posterPath: "/matrix.jpg",
          releaseDate: nil,
          rating: 8.7
        )
      )
    )
    let viewModel = MovieDetailsViewModel(movieID: 603, repository: repository)

    await viewModel.onAppear()

    guard case let .loaded(details) = viewModel.state else {
      Issue.record("Expected loaded state")
      return
    }

    #expect(details.id == 603)
  }

  @Test
  func retryAfterFailureLoadsMovieDetails() async {
    let repository = MovieDetailsRepositorySpy(result: .failure(.networkUnavailable))
    let viewModel = MovieDetailsViewModel(movieID: 603, repository: repository)

    await viewModel.onAppear()
    #expect(movieDetailsError(from: viewModel.state) == .networkUnavailable)

    repository.result = .success(
      MovieDetails(
        id: 603,
        title: "The Matrix",
        overview: "Overview",
        posterPath: "/matrix.jpg",
        releaseDate: nil,
        rating: 8.7
      )
    )

    await viewModel.retry()

    guard case let .loaded(details) = viewModel.state else {
      Issue.record("Expected loaded state after retry")
      return
    }

    #expect(details.id == 603)
  }
}

private func movieDetailsError(from state: MovieDetailsScreenState) -> AppError? {
  guard case let .failed(error) = state else { return nil }
  return error
}

@MainActor
private final class MovieDetailsRepositorySpy: MovieDetailsRepository {
  var result: Result<MovieDetails, AppError>

  init(result: Result<MovieDetails, AppError>) {
    self.result = result
  }

  func fetchMovieDetails(for movieID: Int) async throws -> MovieDetails {
    try result.get()
  }
}
