//
//  BookNoteRepository.swift
//  ReadLog
//
//  Created by sanghyo on 1/5/24.
//

import Foundation

protocol BookNoteRepository {
    
    func getAllBookNote(isbn: String) -> Result<[ReadLog], Error>
    func addBookNote(_ note: ReadLog, to book: BookInfo) -> Result<ReadLog, Error>
}
