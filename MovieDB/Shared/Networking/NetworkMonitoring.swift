//
//  NetworkMonitoring.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Network

protocol NetworkMonitoring: AnyObject {
  var isConnected: Bool { get }
}

final class DefaultNetworkMonitor: NetworkMonitoring {
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "movieDB.network-monitor")
  private(set) var isConnected = true

  init() {
    monitor.pathUpdateHandler = { [weak self] path in
      self?.isConnected = path.status == .satisfied
    }
    monitor.start(queue: queue)
  }

  deinit {
    monitor.cancel()
  }
}

final class MockNetworkMonitor: NetworkMonitoring {
  var isConnected: Bool

  init(isConnected: Bool = true) {
    self.isConnected = isConnected
  }
}
