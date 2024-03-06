//
//  BookInfoRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/6/24.
//

import Foundation

protocol BookInfoRepository {
    func fetchBookInfo(with isbn: String) -> [BookInfo]
    func addBookInfo(book: BookInfo)
}
