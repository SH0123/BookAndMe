//
//  JsonResponse.swift
//  ReadLog
//
//  Created by 유석원 on 12/4/23.
//

import Foundation

struct JsonResponse: Codable {
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
    let item: [BookDataJsonResponse]
}
