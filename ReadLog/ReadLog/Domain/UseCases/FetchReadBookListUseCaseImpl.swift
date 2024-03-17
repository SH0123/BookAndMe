//
//  FetchReadBookListUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/9/24.
//

import Foundation

protocol FetchReadBookListUseCase {
    func execute(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void)
}

final class FetchReadBookListUseCaseImpl: FetchReadBookListUseCase {
    private let readBookRepository: ReadBookRepository
    
    init(readBookRepository: ReadBookRepository = ReadBookCoreDataRepository.shared) {
        self.readBookRepository = readBookRepository
    }

    func execute(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void) {
        readBookRepository.fetchReadBookList(of: userId) { readBookList in
            var readList: [BookInfo] = []
            var dictionary: [String: Bool] = [:]
            for record in readBookList {
                if !dictionary.keys.contains(record.isbn!) {
                    dictionary[record.isbn!] = true
                    readList.append(record)
                }
            }
            completion(readList)
        }
    }
}
