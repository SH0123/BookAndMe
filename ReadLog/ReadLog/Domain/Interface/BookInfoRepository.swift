//
//  BookInfoRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/6/24.
//

import Foundation

protocol BookInfoRepository {
    func fetchReadingBookList(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void)
    func fetchLikeBookList(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void)
    func fetchAllBookList(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void)
    func fetchBookInfo(with isbn: String, _ completion: @escaping (BookInfo?) -> Void)
    func addBookInfo(book: BookInfo, _ completion: @escaping (BookInfo) -> Void)
    func updateBookInfo(book: BookInfo, of userId: String?, _ completion: ((BookInfo) -> Void)?)
}
