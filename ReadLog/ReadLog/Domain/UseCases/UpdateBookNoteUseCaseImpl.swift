//
//  UpdateBookNoteUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/25/24.
//

import Foundation

protocol UpdateBookNoteUseCase {
    func execute(with note: BookNote, of userId: String?, _ completion: @escaping (BookNote?)->Void)
}

struct UpdateBookNoteUseCaseImpl: UpdateBookNoteUseCase {
    private var bookNoteRepository: BookNoteRepository
    
    init(bookNoteRepository: BookNoteRepository = BookNoteCoreDataRepository.shared) {
        self.bookNoteRepository = bookNoteRepository
    }
    func execute(with note: BookNote, of userId: String?, _ completion: @escaping (BookNote?)->Void) {
        bookNoteRepository.updateBookNote(note, of: userId) { note in
            completion(note)
        }
    }
}
