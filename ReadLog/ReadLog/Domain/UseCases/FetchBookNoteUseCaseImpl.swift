//
//  FetchBookNoteUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/25/24.
//

import Foundation

protocol FetchBookNoteUseCase {
    func execute(with noteId: UUID, of userId: String?, _ completion: @escaping (BookNote?)->Void)
}

struct FetchBookNoteUseCaseImpl: FetchBookNoteUseCase {
    private var bookNoteRepository: BookNoteRepository
    
    init(bookNoteRepository: BookNoteRepository = BookNoteCoreDataRepository.shared) {
        self.bookNoteRepository = bookNoteRepository
    }
    func execute(with noteId: UUID, of userId: String?, _ completion: @escaping (BookNote?)->Void) {
        bookNoteRepository.fetchBookNote(with: noteId, of: userId) { note in
            completion(note)
        }
    }
}
