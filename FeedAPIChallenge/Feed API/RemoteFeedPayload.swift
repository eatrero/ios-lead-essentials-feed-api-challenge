//
//  RemoteFeedPayload.swift
//  FeedAPIChallenge
//
//  Created by Atrero, Ed on 8/14/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

internal struct RemoteFeedPayload: Decodable {
	fileprivate let items: [Item]

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
