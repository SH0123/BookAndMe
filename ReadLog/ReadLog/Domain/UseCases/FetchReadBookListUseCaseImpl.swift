//
//  FetchReadBookListUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/9/24.
//

import Foundation

protocol FetchReadBookListUseCase {
    func execute(of userId: String?, _ completion: @escaping ([ReadBook]) -> Void)
}

final class FetchReadBookListUseCaseImpl: FetchReadBookListUseCase {
    private let readBookRepository: ReadBookRepository
    
    init(readBookRepository: ReadBookRepository = ReadBookCoreDataRepository.shared) {
        self.readBookRepository = readBookRepository
    }

    func execute(of userId: String?, _ completion: @escaping ([ReadBook]) -> Void) {
        readBookRepository.fetchReadBookList(of: userId) { readBookList in
            completion(readBookList)
        }
    }
}
