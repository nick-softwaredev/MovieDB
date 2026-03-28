//
//  LoadableState.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

enum LoadableState<Value: Equatable>: Equatable {
  case idle
  case loading
  case loaded(Value)
  case noNetworkConnection
  case failed(AppError)
}
