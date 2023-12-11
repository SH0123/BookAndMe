//
//  BookDataJsonResponse.swift
//  ReadLog
//
//  Created by 유석원 on 12/4/23.
//

import Foundation

struct BookDataJsonResponse: Codable {
    let id: Int
    let isbn: String
    let title: String
    let author: String
    let description: String
    let coverImage: String
    let publisher: String
//    let price: Int
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
//        case price = "priceStandard"
        case link
        case subInfo
    }
}
