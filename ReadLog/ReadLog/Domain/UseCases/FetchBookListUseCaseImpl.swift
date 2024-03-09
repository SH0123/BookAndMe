//
//  FetchReadingBooksUseCase.swift
//  ReadLog
//
//  Created by sanghyo on 3/8/24.
//

import Foundation

protocol FetchBookListUseCase {
    func readingBooks(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void)
    func wishBooks(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void)
    func allBooks(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void)
}

struct FetchBookListUseCaseImpl: FetchBookListUseCase {
    private let bookInfoRepository: BookInfoRepository
    
    init(bookInfoRepository: BookInfoRepository = BookInfoCoreDataRepository.shared) {
        self.bookInfoRepository = bookInfoRepository
    }
    
    func readingBooks(of userId: String?, _ completion: @escaping ([BookInfo])->Void) {
        bookInfoRepository.fetchReadingBookList(of: userId) { bookInfoList in
            completion(bookInfoList)
        }
    }
    
    func wishBooks(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void) {
        bookInfoRepository.fetchLikeBookList(of: userId) { bookInfoList in
            completion(bookInfoList)
        }
    }
    
    func allBooks(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void) {
        bookInfoRepository.fetchAllBookList(of: userId) { bookInfoList in
            completion(bookInfoList)
        }
    }
    
}
