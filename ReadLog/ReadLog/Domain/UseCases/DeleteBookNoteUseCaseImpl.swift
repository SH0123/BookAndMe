//
//  DeleteBookNoteUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/27/24.
//

import Foundation

protocol DeleteBookNoteUseCase {
    func execute(with note: BookNote, of userId: String?, _ completion: @escaping ()->Void)
}

struct DeleteBookNoteUseCaseImpl: DeleteBookNoteUseCase {
    private var bookNoteRepository: BookNoteRepository
    
    init(bookNoteRepository: BookNoteRepository = BookNoteCoreDataRepository.shared) {
        self.bookNoteRepository = bookNoteRepository
    }
    
    func execute(with note: BookNote, of userId: String?, _ completion: @escaping ()->Void) {
        bookNoteRepository.deleteBookNote(note, of: userId, completion)
    }
}
