//
//  MovieDetailsMockView.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import SwiftUI

struct MovieDetailsView<ViewModel: MovieDetailsViewModeling>: View {
  private let posterWidth: CGFloat = 260
  @StateObject private var viewModel: ViewModel
  private let imageLoader: ImageLoading
  private let posterURLBuilder: PosterURLBuilding
  private let onRouteRequested: (AppRoute) -> Void

  init(
    viewModel: ViewModel,
    imageLoader: ImageLoading,
    posterURLBuilder: PosterURLBuilding,
    onRouteRequested: @escaping (AppRoute) -> Void
  ) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self.imageLoader = imageLoader
    self.posterURLBuilder = posterURLBuilder
    self.onRouteRequested = onRouteRequested
  }

  var body: some View {
    Group {
      switch viewModel.state {
      case .idle, .loading:
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      case let .loaded(movieDetails):
        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            if let posterURL = posterURLBuilder.makePosterURL(path: movieDetails.posterPath) {
              RemoteImageView(url: posterURL, imageLoader: imageLoader) {
                RoundedRectangle(cornerRadius: 16)
                  .fill(Color(.tertiarySystemFill))
                  .overlay {
                    ProgressView()
                  }
              }
              .frame(width: posterWidth, height: posterWidth * 1.5)
              .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
              .frame(maxWidth: .infinity, alignment: .center)
            }

            Text(movieDetails.title)
              .font(.largeTitle.bold())

            Text(releaseDateText(for: movieDetails))
              .font(.subheadline)
              .foregroundStyle(.secondary)

            Text("Rating: \(movieDetails.rating, specifier: "%.1f")")
              .font(.headline)

            Text(movieDetails.overview)
              .font(.body)
              .foregroundStyle(.primary)

            Button("Open Next Screen") {
              onRouteRequested(.movieDetailsNextScreen)
            }
            .buttonStyle(.borderedProminent)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(24)
        }
      case .noNetworkConnection:
        VStack(spacing: 12) {
          Text("No internet connection")
            .font(.title3.weight(.semibold))

          Text("Please check your network and try again.")
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)

          Button("Retry") {
            Task {
              await viewModel.retry()
            }
          }
          .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      case let .failed(error):
        VStack(spacing: 12) {
          Text("Couldn’t load movie details")
            .font(.title3.weight(.semibold))

          Text(error.userMessage)
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)

          Button("Retry") {
            Task {
              await viewModel.retry()
            }
          }
          .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .background(Color(.systemBackground))
    .navigationBarTitleDisplayMode(.inline)
    .task {
      await viewModel.onAppear()
    }
  }

  private func releaseDateText(for movieDetails: MovieDetails) -> String {
    guard let releaseDate = movieDetails.releaseDate else {
      return "Release date unavailable"
    }

    return releaseDate.formatted(date: .abbreviated, time: .omitted)
  }
}
