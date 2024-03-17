//
//  ReadBookCoreDataRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/9/24.
//

import Foundation
import CoreData

final class ReadBookCoreDataRepository: ReadBookRepository {
    static let shared: ReadBookRepository = ReadBookCoreDataRepository()
    private var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    private init() {}
    
    func fetchReadBookList(of userId: String?, _ completion: @escaping ([BookInfo]) -> Void) {
        let fetchRequest: NSFetchRequest<ReadBookEntity>
        
        fetchRequest = ReadBookEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ReadBookEntity.endDate, ascending: false)]
        
        do {
            let objects = try context.fetch(fetchRequest)
            
            completion(objects.compactMap { $0.bookInfo?.toDomain() })
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func addReadBook(readBook: ReadBook, bookInfo: BookInfo, of userId: String?, _ completion: @escaping (BookInfo)->Void) {
        // bookinfo reading state 변경 domain과 db entity 둘 다 해줘야함
        guard let isbn = bookInfo.isbn else { return }
        let bookInfoEntity = getBookInfoEntity(isbn: isbn)
        let newReadBook = ReadBookEntity(context: context)
        newReadBook.id = readBook.id
        newReadBook.startDate = readBook.startDate
        newReadBook.endDate = readBook.endDate
        newReadBook.bookInfo = bookInfoEntity
        
        if var readList = bookInfoEntity?.readBooks {
            readList = readList.adding(newReadBook) as NSSet
            bookInfoEntity?.readBooks = readList
        } else {
            bookInfoEntity?.readBooks = [newReadBook]
        }
                
        do {
            try context.save()
            completion(bookInfo)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }

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
