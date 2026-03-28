//
//  ImageLoading.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import UIKit

protocol ImageLoading {
  func loadImage(from url: URL) async throws -> UIImage
}

protocol ImageCaching: AnyObject {
  func image(for url: URL) -> UIImage?
  func insert(_ image: UIImage, for url: URL)
}

final class InMemoryImageCache: ImageCaching {
  private let storage = NSCache<NSURL, UIImage>()

  func image(for url: URL) -> UIImage? {
    storage.object(forKey: url as NSURL)
  }

  func insert(_ image: UIImage, for url: URL) {
    storage.setObject(image, forKey: url as NSURL)
  }
}
