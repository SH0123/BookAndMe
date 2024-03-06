//
//  BookCoreData.swift
//  ReadLog
//
//  Created by 유석원 on 12/5/23.
//

import Foundation
import UIKit

struct BookInfo {
    let id: Int
    let author: String
    let bookDescription: String
    let image: UIImage
    let isbn: String
    let link: String
    let readingStatus: Bool
    let repeatTime: Int
    let page: Int
    let pinned: Bool
    let publisher: String
    let title: String
    let wish: Bool
}
