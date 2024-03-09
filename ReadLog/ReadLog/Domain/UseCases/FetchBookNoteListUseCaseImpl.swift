//
//  FetchBookNotesUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/8/24.
//

import Foundation

protocol FetchBookNoteListUseCase {
    func execute(with isbn: String, of userId: String?, _ completion: @escaping ([BookNote])->Void)
}

struct FetchBookNoteListUseCaseImpl: FetchBookNoteListUseCase {
    private var bookNoteRepository: BookNoteRepository
    
    init(bookNoteRepository: BookNoteRepository = BookNoteCoreDataRepository.shared) {
        self.bookNoteRepository = bookNoteRepository
    }
    func execute(with isbn: String, of userId: String?, _ completion: @escaping ([BookNote]) -> Void) {
        bookNoteRepository.fetchBookNoteList(with: isbn, of: userId) { notes in
            completion(notes)
        }
    }
    
    
}
