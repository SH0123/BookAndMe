//
//  BookInfoCoreDataRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/6/24.
//

import Foundation
import CoreData

final class BookInfoCoreDataRepository: BookInfoRepository {

    static let shared: BookInfoRepository = BookInfoCoreDataRepository()
    private var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    private init() {}
    
    func fetchReadingBookList(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void) {
        let request: NSFetchRequest<BookInfoEntity>
        request = BookInfoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "readingStatus == true")
        
        do {
            let objects = try context.fetch(request)
            completion(objects.map { $0.toDomain() })
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func fetchLikeBookList(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void) {
        let request: NSFetchRequest<BookInfoEntity>
        request = BookInfoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "wish == true")
        
        do {
            let objects = try context.fetch(request)
            completion(objects.map { $0.toDomain() })
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func fetchAllBookList(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void) {
        let request: NSFetchRequest<BookInfoEntity>
        request = BookInfoEntity.fetchRequest()
        
        do {
            let objects = try context.fetch(request)
            completion(objects.map { $0.toDomain() })
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func fetchBookInfo(with isbn: String, _ completion: @escaping (BookInfo?) -> Void) {
        let request: NSFetchRequest<BookInfoEntity>
        request = BookInfoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let objects = try context.fetch(request)
            completion(objects.first?.toDomain())
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }

    }
    
    func addBookInfo(book: BookInfo, _ completion: @escaping (BookInfo) -> Void) {
        var bookInfoEntity = BookInfoEntity(context: context)
        bookInfoEntity = mappingBookInfoEntity(from: book, to: bookInfoEntity)
        print(bookInfoEntity)
        do {
            try context.save()
            completion(book)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func updateBookInfo(book: BookInfo, of userId: String?, _ completion: ((BookInfo) -> Void)?) {
        guard let isbn = book.isbn else { return }
        guard var bookInfoEntity = getBookInfoEntity(isbn: isbn) else { return }
        bookInfoEntity = mappingBookInfoEntity(from: book, to: bookInfoEntity)
        print(book)
        print(bookInfoEntity.wish)
        do {
            try context.save()
            if let completion {
                completion(book)
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    private func mappingBookInfoEntity(from book: BookInfo, to bookInfoEntity: BookInfoEntity) -> BookInfoEntity {
        bookInfoEntity.id = Int32(book.id)
        bookInfoEntity.author = book.author
        bookInfoEntity.bookDescription = book.bookDescription
        if let imageData = book.image?.pngData() {
            bookInfoEntity.image = imageData
        }
        bookInfoEntity.isbn = book.isbn
        bookInfoEntity.link = book.link
        bookInfoEntity.readingStatus = book.readingStatus
        bookInfoEntity.repeatTime = Int32(book.repeatTime)
        bookInfoEntity.page = Int32(book.page)
        bookInfoEntity.publisher = book.publisher
        bookInfoEntity.title = book.title
        bookInfoEntity.wish = book.wish
        bookInfoEntity.bookNotes = NSSet(array: book.notes.map { $0.toEntity(context: context, bookInfoEntity: bookInfoEntity) })
        bookInfoEntity.readingTrackings = NSSet(array: book.trackings.map { $0.toEntity(context: context, bookInfoEntity: bookInfoEntity) })
        bookInfoEntity.readBooks = NSSet(array: book.readbooks.map { $0.toEntity(context: context, bookInfoEntity: bookInfoEntity) })
        
        return bookInfoEntity
    }
    
    
    private func getBookInfoEntity(isbn: String) -> BookInfoEntity? {
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
