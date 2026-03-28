//
//  MoviesListViewModeling.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

@MainActor
protocol MoviesListViewModeling: AnyObject {
  var state: MoviesListScreenState { get }
  var onStateChange: ((MoviesListScreenState) -> Void)? { get set }
  var moviesCount: Int { get }

  func onViewDidLoad() async
  func retry() async
  func loadNextPageIfNeeded(currentIndex: Int) async
  func movie(at index: Int) -> MovieSummary?
  func didSelectMovie(at index: Int) -> AppRoute?
}
