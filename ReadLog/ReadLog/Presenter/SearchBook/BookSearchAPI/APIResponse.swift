//
//  APIResponse.swift
//  ReadLog
//
//  Created by 유석원 on 11/25/23.
//

import Foundation

struct APIResponse: Codable {
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
    let item: [BookInfoData_Temporal]
    
//    private enum CodingKeys: String, CodingKey {
//        case 
//    }
}
