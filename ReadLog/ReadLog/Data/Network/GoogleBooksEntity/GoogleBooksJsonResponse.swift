//
//  GoogleBooksJsonResponse.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import Foundation

struct GoogleBooksJsonResponse: Codable {
    let kind: String
    let totalItems: Int
    let items: [GoogleBooksJsonItem]
}

struct GoogleBooksJsonItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let publisher: String?
    let description: String?
    let industryIdentifiers: [IndustryIdentifiers]
    let pageCount: Int?
    let imageLinks: ImageLinks
    let infoLink: String?
}
struct ImageLinks: Codable {
    let thumbnail: String
}

struct IndustryIdentifiers: Codable {
    let type: String
    let identifier: String
}
