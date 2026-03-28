//
//  MovieDetailsViewModeling.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Combine

protocol MovieDetailsViewModeling: AnyObject, ObservableObject {
  var movieID: Int { get }
  var state: MovieDetailsScreenState { get }

  func onAppear() async
  func retry() async
}
