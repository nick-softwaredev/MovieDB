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

  init(session: URLSession = .shared) {
    self.session = session
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
    let request = try makeRequest(for: endpoint)
    let (data, response) = try await session.data(for: request)

    guard
      let httpResponse = response as? HTTPURLResponse,
      (200...299).contains(httpResponse.statusCode)
    else {
      throw AppError.invalidResponse
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
