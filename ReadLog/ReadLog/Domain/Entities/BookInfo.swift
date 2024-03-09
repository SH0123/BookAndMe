//
//  BookCoreData.swift
//  ReadLog
//
//  Created by 유석원 on 12/5/23.
//

import UIKit

struct BookInfo: Identifiable {
    let id: Int
    let author: String
    let bookDescription: String
    var coverImageUrl: String
    var image: UIImage?
    let isbn: String?
    let link: String
    var readingStatus: Bool
    let repeatTime: Int
    var page: Int
    var pinned: Bool
    let publisher: String
    let title: String
    var wish: Bool
    let notes: [BookNote]
    let trackings: [ReadingTracking]
    let readbooks: [ReadBook]
}
