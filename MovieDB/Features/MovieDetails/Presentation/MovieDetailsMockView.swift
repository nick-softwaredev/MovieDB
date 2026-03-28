//
//  MovieDetailsMockView.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import SwiftUI

struct MovieDetailsMockView: View {
  let movieDetails: MovieDetails

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Text(movieDetails.title)
          .font(.largeTitle.bold())

        Text(releaseDateText)
          .font(.subheadline)
          .foregroundStyle(.secondary)

        Text("Rating: \(movieDetails.rating, specifier: "%.1f")")
          .font(.headline)

        Text(movieDetails.overview)
          .font(.body)
          .foregroundStyle(.primary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(24)
    }
    .background(Color(.systemBackground))
    .navigationBarTitleDisplayMode(.inline)
  }

  private var releaseDateText: String {
    guard let releaseDate = movieDetails.releaseDate else {
      return "Release date unavailable"
    }

    return releaseDate.formatted(date: .abbreviated, time: .omitted)
  }
}
