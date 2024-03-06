//
//  BookNoteRepository.swift
//  ReadLog
//
//  Created by sanghyo on 1/5/24.
//

import Foundation

protocol BookNoteRepository {
    func fetchBookNoteList(with isbn: String) -> [BookNote]
    func addBookNote(_ note: BookNote, to book: BookInfo)
}
