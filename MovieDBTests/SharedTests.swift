import Foundation
import Testing
import UIKit
@testable import MovieDB

struct MoviesListPaginatorTests {
  @Test
  func startAndFinishLoadingAdvancePaginatorState() {
    var paginator = MoviesListPaginator()

    let firstPage = paginator.startLoadingNextPage()
    paginator.finishLoading(receivedItemCount: 3, loadedPage: firstPage ?? 0)

    #expect(firstPage == 1)
    #expect(paginator.currentPage == 1)
    #expect(paginator.isLoadingPage == false)
    #expect(paginator.hasMorePages == true)
  }

  @Test
  func emptyPageMarksPaginatorAsFinished() {
    var paginator = MoviesListPaginator()

    let page = paginator.startLoadingNextPage()
    paginator.finishLoading(receivedItemCount: 0, loadedPage: page ?? 0)

    #expect(paginator.hasMorePages == false)
    #expect(paginator.startLoadingNextPage() == nil)
  }
}

@MainActor
struct DefaultImageLoaderTests {
  @Test
  func loadImageDecodesAndCachesImage() async throws {
    let url = URL(string: "https://example.com/poster.png")!
    let imageData = makeImageData(color: .red)
    let networkClient = NetworkClientSpy(dataByURL: [url: imageData])
    let imageLoader = DefaultImageLoader(networkClient: networkClient)

    let firstImage = try await imageLoader.loadImage(from: url)
    let secondImage = try await imageLoader.loadImage(from: url)

    #expect(firstImage.size.width > 0)
    #expect(secondImage.size.width > 0)
    #expect(networkClient.requestedURLs == [url])
  }

  @Test
  func loadImageThrowsWhenDataIsNotAnImage() async {
    let url = URL(string: "https://example.com/poster.png")!
    let networkClient = NetworkClientSpy(dataByURL: [url: Data("not-an-image".utf8)])
    let imageLoader = DefaultImageLoader(networkClient: networkClient)

    await #expect(throws: AppError.decodingFailed) {
      try await imageLoader.loadImage(from: url)
    }
  }
}

@MainActor
private func makeImageData(color: UIColor) -> Data {
  let renderer = UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4))
  let image = renderer.image { context in
    color.setFill()
    context.fill(CGRect(x: 0, y: 0, width: 4, height: 4))
  }

  return image.pngData() ?? Data()
}

private final class NetworkClientSpy: NetworkClient {
  let dataByURL: [URL: Data]
  private(set) var requestedURLs: [URL] = []

  init(dataByURL: [URL: Data]) {
    self.dataByURL = dataByURL
  }

  func send<Response>(_ endpoint: APIEndpoint) async throws -> Response where Response : Decodable {
    let data = try await send(endpoint)
    do {
      return try JSONDecoder().decode(Response.self, from: data)
    } catch {
      throw AppError.decodingFailed
    }
  }

  func send(_ endpoint: APIEndpoint) async throws -> Data {
    let url = endpoint.baseURL.appending(path: endpoint.path)
    requestedURLs.append(url)
    guard let data = dataByURL[url] else {
      throw AppError.invalidResponse
    }
    return data
  }
}
