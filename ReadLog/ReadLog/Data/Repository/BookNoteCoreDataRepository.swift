//
//  BookNoteCoreDataRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/8/24.
//

import Foundation
import CoreData

final class BookNoteCoreDataRepository: BookNoteRepository {
    static let shared: BookNoteRepository = BookNoteCoreDataRepository()
    private var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    private init() {}
    
    func fetchBookNoteList(with isbn: String, of userId: String?, _ completion: @escaping ([BookNote])->Void) {
        let fetchRequest: NSFetchRequest<BookNoteEntity>
        
        fetchRequest = BookNoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@",#keyPath(BookNoteEntity.bookInfo.isbn), isbn)
        
        do {
            let objects = try context.fetch(fetchRequest)
            completion(objects.map { $0.toDomain() })
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func addBookNote(_ note: BookNote, to book: BookInfo, of userId: String?, _ completion: @escaping (BookNote)->Void) {
        guard let isbn = book.isbn else { return }
        let book = getBookInfoEntity(with: isbn)
        let newNote = BookNoteEntity(context: context)
        newNote.id = note.id
        newNote.label = Int16(note.label)
        newNote.content = note.content
        newNote.date = note.date
        newNote.bookInfo = book
        
        if var notes = book?.bookNotes {
            notes = notes.adding(newNote) as NSSet
            book?.bookNotes = notes
        } else {
            book?.bookNotes = [newNote]
        }
        
        do {
            try context.save()
            completion(note)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
        
    }
    
    private func getBookInfoEntity(with isbn: String) -> BookInfoEntity? {
        let request: NSFetchRequest<BookInfoEntity>
        request = BookInfoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let objects = try context.fetch(request)
            return objects.first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
}
