//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

private struct Root: Decodable {
	let items: [Item]

	var feed: [FeedImage] {
		return items.map { $0.item }
	}
}

private struct Item: Decodable {
	let image_id: UUID
	let image_desc: String?
	let image_loc: String?
	let image_url: URL

	var item: FeedImage {
		return FeedImage(id: image_id, description: image_desc, location: image_loc, url: image_url)
	}
}

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
		self.client.get(from: self.url) { result in
			switch result {
			case .failure(_):
				completion(.failure(RemoteFeedLoader.Error.connectivity))

			case let .success((data, resp)):
				guard resp.statusCode == 200,
				      let _ = try? JSONDecoder().decode(Root.self, from: data) else {
					completion(.failure(RemoteFeedLoader.Error.invalidData))
					return
				}
				completion(.success([]))
			}
		}
	}
}
