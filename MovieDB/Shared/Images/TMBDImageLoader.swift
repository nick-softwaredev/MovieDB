//
//  DefaultImageLoader.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
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
      AppLogger.info("📦 cache hit: \(url.absoluteString)", category: "ImageLoader")
      return cachedImage
    }

    AppLogger.info("⬇️ network fetch: \(url.absoluteString)", category: "ImageLoader")
    let data = try await networkClient.send(ImageEndpoint(url: url))

    guard let image = UIImage(data: data) else {
      AppLogger.error("Failed to decode image: \(url.absoluteString)", category: "ImageLoader")
      throw AppError.decodingFailed
    }

    cache.insert(image, for: url)
    AppLogger.info("💾 stored in cache: \(url.absoluteString)", category: "ImageLoader")
    return image
  }
}
