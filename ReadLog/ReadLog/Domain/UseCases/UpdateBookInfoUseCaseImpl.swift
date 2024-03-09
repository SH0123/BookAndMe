//
//  UpdateBookInfoUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/9/24.
//

import Foundation

protocol UpdateBookInfoUseCase {
    func execute(book: BookInfo, of userId: String?, _ completion: ((BookInfo?) -> Void)?)
}

final class UpdateBookInfoUseCaseImpl: UpdateBookInfoUseCase {
    private let bookInfoRepository: BookInfoRepository
    
    init(bookInfoRepository: BookInfoRepository = BookInfoCoreDataRepository.shared) {
        self.bookInfoRepository = bookInfoRepository
    }

    func execute(book: BookInfo, of userId: String?, _ completion: ((BookInfo?) -> Void)?) {
        bookInfoRepository.updateBookInfo(book: book, of: userId) { bookInfo in
            if let completion {
                completion(bookInfo)
            }
        }
    }
}
