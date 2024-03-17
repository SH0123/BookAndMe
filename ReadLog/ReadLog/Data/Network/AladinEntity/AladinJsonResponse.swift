//
//  JsonResponse.swift
//  ReadLog
//
//  Created by 유석원 on 12/4/23.
//

import Foundation

struct AladinJsonResponse: Codable {
    let version: String
    let logo: String
    let title: String
    let link: String
    let pubDate: String
    let totalResults: Int
    let startIndex: Int
    let itemsPerPage: Int
    let query: String
    let searchCategoryId: Int
    let searchCategoryName: String
    let item: [AladinJsonResponseItem]
}

struct AladinJsonResponseItem: Codable {
    let id: Int
    let isbn: String
    let title: String
    let author: String
    let description: String
    let coverImage: String
    let publisher: String
    let link: String
    let subInfo: BookSubInfo?
    
    private enum CodingKeys: String, CodingKey {
        case id = "itemId"
        case isbn = "isbn13"
        case title
        case author
        case description
        case coverImage = "cover"
        case publisher
        case link
        case subInfo
    }
}

struct BookSubInfo: Codable {
    let itemPage: Int?
}
