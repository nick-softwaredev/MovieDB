//
//  DefaultImageLoader.swift
//  MovieDB
//
//  Created by Nick Todorashko on 2026-03-28.
//

import UIKit

final class DefaultImageLoader: ImageLoading {
  private let networkClient: NetworkClient
  private let cache: ImageCaching

  init(
    networkClient: NetworkClient,
    cache: ImageCaching = InMemoryImageCache()
  ) {
    self.networkClient = networkClient
    self.cache = cache
  }

  func loadImage(from url: URL) async throws -> UIImage {
    if let cachedImage = cache.image(for: url) {
      return cachedImage
    }

    let data = try await networkClient.send(ImageEndpoint(url: url))

    guard let image = UIImage(data: data) else {
      throw AppError.decodingFailed
    }

    cache.insert(image, for: url)
    return image
  }
}
