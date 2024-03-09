//
//  FetchBookInfoUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/9/24.
//

import Foundation

protocol FetchBookInfoUseCase {
    func execute(with isbn: String, _ completion: @escaping (BookInfo?) -> Void)
}

final class FetchBookInfoUseCaseImpl: FetchBookInfoUseCase {
    private let bookInfoRepository: BookInfoRepository
    
    init(bookInfoRepository: BookInfoRepository = BookInfoCoreDataRepository.shared) {
        self.bookInfoRepository = bookInfoRepository
    }

    func execute(with isbn: String, _ completion: @escaping (BookInfo?) -> Void) {
        bookInfoRepository.fetchBookInfo(with: isbn) { bookInfo in
            completion(bookInfo)
        }
    }
}
