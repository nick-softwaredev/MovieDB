//
//  MoviesListPaginator.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

struct MoviesListPaginator {
  private(set) var currentPage = 0
  private(set) var isLoadingPage = false
  private(set) var hasMorePages = true

  mutating func reset() {
    currentPage = 0
    isLoadingPage = false
    hasMorePages = true
  }

  mutating func startLoadingNextPage() -> Int? {
    guard !isLoadingPage, hasMorePages else { return nil }
    isLoadingPage = true
    return currentPage + 1
  }

  mutating func finishLoading(receivedItemCount: Int, loadedPage: Int) {
    currentPage = loadedPage
    hasMorePages = receivedItemCount > 0
    isLoadingPage = false
  }

  mutating func finishLoadingAfterError() {
    isLoadingPage = false
  }
}
