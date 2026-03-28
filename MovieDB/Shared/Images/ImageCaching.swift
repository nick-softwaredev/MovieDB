//
//  ImageCaching.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import UIKit

protocol ImageCaching: AnyObject {
  func image(for url: URL) -> UIImage?
  func insert(_ image: UIImage, for url: URL)
}
