//
//  NewsResponse.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 28/4/23.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String
    let numResults: Int
    let results: [News]
    
    enum CodingKeys: String, CodingKey {
        case status
        case numResults = "num_results"
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        self.numResults = try container.decodeIfPresent(Int.self, forKey: .numResults) ?? 0
        self.results = try container.decodeIfPresent([News].self, forKey: .results) ?? []
    }
}
