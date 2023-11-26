//
//  BookInfoData_Temporal.swift
//  ReadLog
//
//  Created by 유석원 on 11/25/23.
//

import Foundation

struct BookInfoData_Temporal: Codable, Identifiable {
    let id: Int
    let isbn: String
    let isbn13: String
    let title: String
    let author: String
    let pubDate: String
    let description: String
    let coverImage: String
    let publisher: String
    let priceStandard: Int
    
//    let link: String
//    let priceSales: Int
//    let mallType: String
//    let stockStatus: String
//    let mileage: Int
//    let categoryId: Int
//    let categoryName: String
//    let salesPoint: Int
//    let adult: Bool
//    let fixedPrice: Bool
//    let customerReviewRank: Int
//    let seriesInfo // object
//    let subInfo // object
    
    private enum CodingKeys: String, CodingKey {
        case id = "itemId"
        case isbn
        case isbn13
        case title
        case author
        case pubDate
        case description
        case coverImage = "cover"
        case publisher
        case priceStandard
    }
}
