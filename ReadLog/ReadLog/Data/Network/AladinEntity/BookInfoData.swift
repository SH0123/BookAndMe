//
//  BookInfoData.swift
//  ReadLog
//
//  Created by 유석원 on 11/25/23.
//

import Foundation

struct BookInfoData: Codable, Identifiable {
    let id: Int
    let isbn: String
    let title: String
    let author: String
    let description: String
    let coverImage: String
    let publisher: String
//    let price: Int
    let link: String
    let itemPage: Int
    
    let dbImage: Data?
    let dbWish: Bool
    let dbNthCycle: Int
    
}
