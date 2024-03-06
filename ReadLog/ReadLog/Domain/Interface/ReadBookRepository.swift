//
//  ReadBookRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/6/24.
//

import Foundation

protocol ReadBookRepository {
    func fetchAllReadBookList() -> [ReadBook]
    func fetchReadBook(with isbn: String) -> [ReadBook]
    func addReadBook(_ readBook: ReadBook, to: BookInfo)
}
