//
//  AddBookNoteUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/8/24.
//

import Foundation

protocol AddBookNoteUseCase {
    func execute(_ note: BookNote, to book: BookInfo, of userId: String?, _ completion: @escaping (BookNote)->Void)
}

struct AddBookNoteUseCaseImpl: AddBookNoteUseCase {
    private var bookNoteRepository: BookNoteRepository
    
    init(bookNoteRepository: BookNoteRepository = BookNoteCoreDataRepository.shared) {
        self.bookNoteRepository = bookNoteRepository
    }
    
    func execute(_ note: BookNote, to book: BookInfo, of userId: String?, _ completion: @escaping (BookNote) -> Void) {
        bookNoteRepository.addBookNote(note, to: book, of: userId) { bookNote in
            completion(bookNote)
        }
    }
}
