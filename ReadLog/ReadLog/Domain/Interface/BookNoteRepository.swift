//
//  BookNoteRepository.swift
//  ReadLog
//
//  Created by sanghyo on 1/5/24.
//

import Foundation

protocol BookNoteRepository {
    func fetchBookNoteList(with isbn: String, of userId: String?, _ completion: @escaping ([BookNote])->Void)
    func fetchBookNote(with noteId: UUID, of userId: String?, _ completion: @escaping (BookNote?)->Void)
    func addBookNote(_ note: BookNote, to book: BookInfo, of userId: String?, _ completion: @escaping (BookNote)->Void)
    func updateBookNote(_ note: BookNote, of userId: String?, _ completion: @escaping (BookNote)->Void)
    func deleteBookNote(_ note: BookNote, of userId: String?, _ completion: @escaping ()->Void)
}
