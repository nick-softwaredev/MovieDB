//
//  RemoteImageView.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import SwiftUI
import Combine

@MainActor
final class RemoteImageViewModel: ObservableObject {
  @Published private(set) var image: UIImage?

  private let imageLoader: ImageLoading
  private var imageLoadTask: Task<Void, Never>?

  init(imageLoader: ImageLoading) {
    self.imageLoader = imageLoader
  }

  deinit {
    imageLoadTask?.cancel()
  }

  func load(from url: URL?) {
    imageLoadTask?.cancel()
    image = nil

    guard let url else { return }

    imageLoadTask = Task { [weak self] in
      guard let self else { return }

      do {
        let loadedImage = try await imageLoader.loadImage(from: url)
        guard !Task.isCancelled else { return }
        image = loadedImage
      } catch {
        guard !Task.isCancelled else { return }
        image = nil
      }
    }
  }
}

struct RemoteImageView<Placeholder: View>: View {
  private let url: URL?
  private let placeholder: Placeholder
  @StateObject private var viewModel: RemoteImageViewModel

  init(
    url: URL?,
    imageLoader: ImageLoading,
    @ViewBuilder placeholder: () -> Placeholder
  ) {
    self.url = url
    self.placeholder = placeholder()
    _viewModel = StateObject(wrappedValue: RemoteImageViewModel(imageLoader: imageLoader))
  }

  var body: some View {
    Group {
      if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
      } else {
        placeholder
      }
    }
    .task(id: url) {
      viewModel.load(from: url)
    }
  }
}
