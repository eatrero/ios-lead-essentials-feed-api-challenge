//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

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
				      let _ = try? JSONDecoder().decode(RemoteFeedPayload.self, from: data) else {
					completion(.failure(RemoteFeedLoader.Error.invalidData))
					return
				}
				completion(.success([]))
			}
		}
	}
}
