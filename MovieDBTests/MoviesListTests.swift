import Foundation
import Testing
@testable import MovieDB

struct MoviesListRepositoryTests {
  @Test
  func fetchPopularMoviesReturnsRequestedPageSlice() async throws {
    let repository = MockMoviesListRepository(
      movieCatalog: MockMovieCatalog(),
      pageSize: 10
    )

    let firstPage = try await repository.fetchPopularMovies(page: 1)
    let secondPage = try await repository.fetchPopularMovies(page: 2)
    let thirdPage = try await repository.fetchPopularMovies(page: 3)

    #expect(firstPage.count == 10)
    #expect(secondPage.count == 10)
    #expect(thirdPage.isEmpty)
    #expect(firstPage.first?.id == 603)
    #expect(secondPage.first?.id == 550)
  }
}

@MainActor
struct MoviesListViewModelTests {
  @Test
  func onViewDidLoadLoadsFirstPage() async {
    let repository = MoviesListRepositorySpy(pages: [
      1: [
        MovieSummary(id: 1, title: "One", posterPath: "/one.jpg"),
        MovieSummary(id: 2, title: "Two", posterPath: "/two.jpg")
      ]
    ])
    let viewModel = MoviesListViewModel(repository: repository)

    await viewModel.onViewDidLoad()

    #expect(viewModel.moviesCount == 2)
    #expect(viewModel.movie(at: 0)?.title == "One")
    #expect(repository.requestedPages == [1])
    #expect(loadedMovies(from: viewModel.state)?.count == 2)
  }

  @Test
  func loadNextPageIfNeededAppendsNextPageAtLastItem() async {
    let repository = MoviesListRepositorySpy(pages: [
      1: [
        MovieSummary(id: 1, title: "One", posterPath: "/one.jpg"),
        MovieSummary(id: 2, title: "Two", posterPath: "/two.jpg")
      ],
      2: [
        MovieSummary(id: 3, title: "Three", posterPath: "/three.jpg")
      ]
    ])
    let viewModel = MoviesListViewModel(repository: repository)

    await viewModel.onViewDidLoad()
    await viewModel.loadNextPageIfNeeded(currentIndex: 1)

    #expect(viewModel.moviesCount == 3)
    #expect(viewModel.movie(at: 2)?.title == "Three")
    #expect(repository.requestedPages == [1, 2])
  }

  @Test
  func retryAfterFailureTransitionsToLoadedState() async {
    let repository = MoviesListRepositorySpy(
      pages: [1: [MovieSummary(id: 1, title: "One", posterPath: "/one.jpg")]],
      failures: [1: .networkUnavailable]
    )
    let viewModel = MoviesListViewModel(repository: repository)

    await viewModel.onViewDidLoad()
    #expect(viewModel.state == .noNetworkConnection)

    repository.failures = [:]
    await viewModel.retry()

    #expect(viewModel.moviesCount == 1)
    #expect(loadedMovies(from: viewModel.state)?.first?.id == 1)
    #expect(repository.requestedPages == [1, 1])
  }
}

private func loadedMovies(from state: MoviesListScreenState) -> [MovieSummary]? {
  guard case let .loaded(movies) = state else { return nil }
  return movies
}

@MainActor
private final class MoviesListRepositorySpy: MoviesListRepository {
  let pages: [Int: [MovieSummary]]
  var failures: [Int: AppError] = [:]
  private(set) var requestedPages: [Int] = []

  init(
    pages: [Int: [MovieSummary]],
    failures: [Int: AppError] = [:]
  ) {
    self.pages = pages
    self.failures = failures
  }

  func fetchPopularMovies(page: Int) async throws -> [MovieSummary] {
    requestedPages.append(page)
    if let error = failures[page] {
      throw error
    }
    return pages[page, default: []]
  }
}
