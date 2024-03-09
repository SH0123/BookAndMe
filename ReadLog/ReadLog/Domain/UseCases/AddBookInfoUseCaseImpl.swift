//
//  AddBookInfoUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/9/24.
//

import Foundation

protocol AddBookInfoUseCase {
    func execute(book: BookInfo)
}

final class AddBookInfoUseCaseImpl: AddBookInfoUseCase {
    private let bookInfoRepository: BookInfoRepository
    
    init(bookInfoRepository: BookInfoRepository = BookInfoCoreDataRepository.shared) {
        self.bookInfoRepository = bookInfoRepository
    }

    func execute(book: BookInfo) {
        bookInfoRepository.addBookInfo(book: book)
    }
}
