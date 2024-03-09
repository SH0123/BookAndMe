//
//  ReadBookRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/6/24.
//

import Foundation

protocol ReadBookRepository {
    func fetchReadBookList(of userId: String?, _ completion: @escaping ([ReadBook])->Void)
    func addReadBook(readBook: ReadBook, bookInfo: BookInfo, of userId: String?, _ completion: @escaping (BookInfo)->Void)
}
