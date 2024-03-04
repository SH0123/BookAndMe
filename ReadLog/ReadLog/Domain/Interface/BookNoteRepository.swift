//
//  BookNoteRepository.swift
//  ReadLog
//
//  Created by sanghyo on 1/5/24.
//

import Foundation

protocol BookNoteRepository {
    
    func getAllBookNote(isbn: String) -> Result<[BookNoteEntity], Error>
    func addBookNote(_ note: BookNoteEntity, to book: BookInfoEntity) -> Result<BookNoteEntity, Error>
}
