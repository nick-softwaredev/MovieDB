//
//  NetworkClient.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import Foundation

protocol NetworkClient {
  func send<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response
  func send(_ endpoint: APIEndpoint) async throws -> Data
}

struct URLSessionNetworkClient: NetworkClient {
  private let session: URLSession
  private let networkMonitor: NetworkMonitoring

  init(
    session: URLSession = .shared,
    networkMonitor: NetworkMonitoring
  ) {
    self.session = session
    self.networkMonitor = networkMonitor
  }

  func send<Response: Decodable>(_ endpoint: APIEndpoint) async throws -> Response {
    let data = try await send(endpoint)

    do {
      return try JSONDecoder().decode(Response.self, from: data)
    } catch {
      throw AppError.decodingFailed
    }
  }

  func send(_ endpoint: APIEndpoint) async throws -> Data {
    guard networkMonitor.isConnected else {
      throw AppError.networkUnavailable
    }

    let request = try makeRequest(for: endpoint)
    let (data, response): (Data, URLResponse)

    do {
      (data, response) = try await session.data(for: request)
    } catch let error as URLError where error.code == .notConnectedToInternet {
      throw AppError.networkUnavailable
    } catch {
      throw error
    }

    guard
      let httpResponse = response as? HTTPURLResponse,
      (200...299).contains(httpResponse.statusCode)
    else {
      throw AppError.invalidResponse
    }

    if let rawResponse = String(data: data, encoding: .utf8) {
      print("Raw response for \(endpoint.path):\n\(rawResponse)")
    }

    return data
  }

  private func makeRequest(for endpoint: APIEndpoint) throws -> URLRequest {
    guard var components = URLComponents(
      url: endpoint.baseURL.appending(path: endpoint.path),
      resolvingAgainstBaseURL: false
    ) else {
      throw AppError.invalidRequest
    }

    components.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems

    guard let url = components.url else {
      throw AppError.invalidRequest
    }

    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method.rawValue
    endpoint.headers.forEach { key, value in
      request.setValue(value, forHTTPHeaderField: key)
    }
    return request
  }
}
