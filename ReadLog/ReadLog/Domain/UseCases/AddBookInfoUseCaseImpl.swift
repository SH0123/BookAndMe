//
//  AddBookInfoUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/9/24.
//

import Foundation

protocol AddBookInfoUseCase {
    func execute(book: BookInfo, _ completion: @escaping (BookInfo) -> Void)
}

final class AddBookInfoUseCaseImpl: AddBookInfoUseCase {
    private let bookInfoRepository: BookInfoRepository
    
    init(bookInfoRepository: BookInfoRepository = BookInfoCoreDataRepository.shared) {
        self.bookInfoRepository = bookInfoRepository
    }

    func execute(book: BookInfo, _ completion: @escaping (BookInfo) -> Void) {
        bookInfoRepository.addBookInfo(book: book) { bookInfo in
            completion(bookInfo)
        }
    }
}
