//
//  MockImageServices.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import UIKit

enum MockImageLoaderMode {
  case success
  case failure(AppError)
}

final class MockImageLoader: ImageLoading {
  private let imagesByURL: [URL: UIImage]
  private let mode: MockImageLoaderMode

  init(
    imagesByURL: [URL: UIImage] = [:],
    mode: MockImageLoaderMode = .success
  ) {
    self.imagesByURL = imagesByURL
    self.mode = mode
  }

  func loadImage(from url: URL) async throws -> UIImage {
    switch mode {
    case .success:
      if let image = imagesByURL[url] {
        return image
      }
      throw AppError.invalidResponse
    case let .failure(error):
      throw error
    }
  }
}

struct MockPosterURLBuilder: PosterURLBuilding {
  private let urlsByPath: [String: URL]

  init(urlsByPath: [String: URL] = [:]) {
    self.urlsByPath = urlsByPath
  }

  func makePosterURL(path: String?) -> URL? {
    guard let path, !path.isEmpty else { return nil }
    return urlsByPath[path]
  }
}
