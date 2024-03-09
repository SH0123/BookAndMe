//
//  AddReadBookUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/9/24.
//

import Foundation

protocol AddReadBookUseCase {
    func execute(readBook: ReadBook, bookInfo: BookInfo, of userId: String?, _ completion: @escaping (BookInfo)->Void)
}

final class AddReadBookUseCaseImpl: AddReadBookUseCase {
    private let readBookRepository: ReadBookRepository
    
    init(readBookRepository: ReadBookRepository = ReadBookCoreDataRepository.shared) {
        self.readBookRepository = readBookRepository
    }

    func execute(readBook: ReadBook, bookInfo: BookInfo, of userId: String?, _ completion: @escaping (BookInfo)->Void) {
        readBookRepository.addReadBook(readBook: readBook, bookInfo: bookInfo, of: userId) { bookInfo in
            completion(bookInfo)
        }
    }
}
