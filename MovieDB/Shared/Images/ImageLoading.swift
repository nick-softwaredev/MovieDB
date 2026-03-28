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
