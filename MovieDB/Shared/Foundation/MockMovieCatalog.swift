//
//  MockMovieCatalog.swift
//  MovieDB
//
//  Created by N on 2026-03-28.
//

import Foundation

protocol MockMovieCataloging {
  var popularMovies: [MovieSummary] { get }

  func details(for movieID: Int) -> MovieDetails?
}

struct MockMovieCatalog: MockMovieCataloging {
  private let records: [MockMovieRecord] = [
    .init(id: 603, title: "The Matrix", overview: "A computer hacker learns the nature of reality and joins the rebellion against the machines.", posterPath: "/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg", releaseDate: Date(timeIntervalSince1970: 922060800), rating: 8.7),
    .init(id: 155, title: "The Dark Knight", overview: "Batman faces the Joker as Gotham descends into chaos and moral compromise.", posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg", releaseDate: Date(timeIntervalSince1970: 1215734400), rating: 8.5),
    .init(id: 680, title: "Pulp Fiction", overview: "Interconnected crime stories collide in a darkly comic Los Angeles underworld.", posterPath: "/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg", releaseDate: Date(timeIntervalSince1970: 780624000), rating: 8.5),
    .init(id: 13, title: "Forrest Gump", overview: "A kindhearted man witnesses and shapes decades of American history through chance and persistence.", posterPath: "/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg", releaseDate: Date(timeIntervalSince1970: 776217600), rating: 8.4),
    .init(id: 27205, title: "Inception", overview: "A skilled thief enters layered dreams to plant an idea inside a target’s mind.", posterPath: "/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg", releaseDate: Date(timeIntervalSince1970: 1279324800), rating: 8.4),
    .init(id: 238, title: "The Godfather", overview: "The aging patriarch of a crime family transfers power to a reluctant son.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", releaseDate: Date(timeIntervalSince1970: 71280000), rating: 8.7),
    .init(id: 424, title: "Schindler's List", overview: "An industrialist becomes an unlikely protector during one of history’s darkest periods.", posterPath: "/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg", releaseDate: Date(timeIntervalSince1970: 756864000), rating: 8.6),
    .init(id: 240, title: "The Godfather Part II", overview: "A crime empire expands while a family legacy fractures under power and paranoia.", posterPath: "/hek3koDUyRQk7FIhPXsa6mT2Zc3.jpg", releaseDate: Date(timeIntervalSince1970: 157766400), rating: 8.6),
    .init(id: 122, title: "The Lord of the Rings: The Return of the King", overview: "The final battle for Middle-earth arrives as friendships and kingdoms are tested.", posterPath: "/rCzpDGLbOoPwLjy3OAm5NUPOTrC.jpg", releaseDate: Date(timeIntervalSince1970: 1071705600), rating: 8.5),
    .init(id: 157336, title: "Interstellar", overview: "Explorers travel beyond known space in search of a future for humanity.", posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg", releaseDate: Date(timeIntervalSince1970: 1415145600), rating: 8.4),
    .init(id: 550, title: "Fight Club", overview: "An insomniac and a soap salesman ignite a movement that spirals out of control.", posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg", releaseDate: Date(timeIntervalSince1970: 939600000), rating: 8.4),
    .init(id: 497, title: "The Green Mile", overview: "A prison guard encounters a death row inmate with a miraculous gift.", posterPath: "/8VG8fDNiy50H4FedGwdSVUPoaJe.jpg", releaseDate: Date(timeIntervalSince1970: 945734400), rating: 8.5),
    .init(id: 769, title: "GoodFellas", overview: "A young man is drawn into the glamour and brutality of organized crime.", posterPath: "/aKuFiU82s5ISJpGZp7YkIr3kCUd.jpg", releaseDate: Date(timeIntervalSince1970: 653875200), rating: 8.4),
    .init(id: 120, title: "The Lord of the Rings: The Fellowship of the Ring", overview: "A quiet journey begins as a fellowship forms to destroy a powerful ring.", posterPath: "/6oom5QYQ2yQTMJIbnvbkBL9cHo6.jpg", releaseDate: Date(timeIntervalSince1970: 1008633600), rating: 8.4),
    .init(id: 121, title: "The Lord of the Rings: The Two Towers", overview: "The fellowship breaks apart as separate battles decide the fate of Middle-earth.", posterPath: "/5VTN0pR8gcqV3EPUHHfMGnJYN9L.jpg", releaseDate: Date(timeIntervalSince1970: 1040169600), rating: 8.4),
    .init(id: 278, title: "The Shawshank Redemption", overview: "Two prisoners forge a bond that outlives the walls around them.", posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg", releaseDate: Date(timeIntervalSince1970: 780364800), rating: 8.7),
    .init(id: 1891, title: "The Empire Strikes Back", overview: "Rebels face a crushing counterattack as truths emerge across the galaxy.", posterPath: "/nNAeTmF4CtdSgMDplXTDPOpYzsX.jpg", releaseDate: Date(timeIntervalSince1970: 327628800), rating: 8.4),
    .init(id: 807, title: "Se7en", overview: "Two detectives follow a serial killer whose crimes are built around deadly sins.", posterPath: "/6yoghtyTpznpBik8EngEmJskVUO.jpg", releaseDate: Date(timeIntervalSince1970: 811209600), rating: 8.3),
    .init(id: 1124, title: "The Prestige", overview: "A rivalry between magicians turns obsession into sacrifice and deception.", posterPath: "/bdN3gXuIZYaJP7ftKK2sU0nPtEA.jpg", releaseDate: Date(timeIntervalSince1970: 1161216000), rating: 8.2),
    .init(id: 98, title: "Gladiator", overview: "A betrayed general returns as a gladiator to confront an emperor and reclaim honor.", posterPath: "/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg", releaseDate: Date(timeIntervalSince1970: 957398400), rating: 8.2)
  ]

  var popularMovies: [MovieSummary] {
    records.map {
      MovieSummary(
        id: $0.id,
        title: $0.title,
        posterPath: $0.posterPath
      )
    }
  }

  func details(for movieID: Int) -> MovieDetails? {
    guard let record = records.first(where: { $0.id == movieID }) else {
      return nil
    }

    return MovieDetails(
      id: record.id,
      title: record.title,
      overview: record.overview,
      posterPath: record.posterPath,
      releaseDate: record.releaseDate,
      rating: record.rating
    )
  }
}

private struct MockMovieRecord {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String?
  let releaseDate: Date?
  let rating: Double
}
