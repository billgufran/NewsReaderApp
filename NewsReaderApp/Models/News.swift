//
//  News.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 28/4/23.
//

import Foundation

struct News: Decodable {
    let url: String
    let id: Int
    let publishDate: String
    let section: String
    let title: String
    let media: [Media]
    
    enum CodingKeys: String, CodingKey {
        case url
        case id
        case publishDate = "published_date"
        case section
        case title
        case media
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.publishDate = try container.decodeIfPresent(String.self, forKey: .publishDate) ?? ""
        self.section = try container.decodeIfPresent(String.self, forKey: .section) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.media = try container.decodeIfPresent([Media].self, forKey: .media) ?? []
    }
    
    init(
        url: String,
        id: Int,
        publishDate: String,
        section: String,
        title: String,
        mediaUrl: String
    ) {
        self.url = url
        self.id = id
        self.publishDate = publishDate
        self.section = section
        self.title = title
        self.media = [Media(type: "", caption: "", metadata: [MediaMetadata(url: mediaUrl, format: "", height: 0, width: 0)])]
    }
}
