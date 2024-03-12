//
//  ReadingTrackingCoreDataRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/8/24.
//

import Foundation
import CoreData

final class ReadingTrackingCoreDataRepository: ReadingTrackingRepository {
    static let shared: ReadingTrackingRepository = ReadingTrackingCoreDataRepository()
    private var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    private init() {}
    
    func fetchReadingTrackingList(with isbn: String, of userId: String?, _ completion: @escaping ([ReadingTracking]) -> Void) {
        let fetchRequest: NSFetchRequest<ReadingTrackingEntity>
        
        fetchRequest = ReadingTrackingEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ReadingTrackingEntity.readDate, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "bookInfo.isbn == %@",isbn)
        
        do {
            let objects = try context.fetch(fetchRequest)
            completion(objects.map { $0.toDomain() })
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
        
    }
    
    func addReadingTracking(_ tracking: ReadingTracking, to bookInfo: BookInfo, of userId: String?,  _ completion: @escaping (ReadingTracking)->Void) {
        guard let isbn = bookInfo.isbn else { return }
        guard let bookInfoEntity = getBookInfoEntity(with: isbn) else { return }
        let readingTracking = ReadingTrackingEntity(context: context)
        readingTracking.id = tracking.id
        readingTracking.readPage = Int32(tracking.readPage)
        readingTracking.readDate = tracking.readDate
        readingTracking.bookInfo = bookInfoEntity
        
        if var readingList = bookInfoEntity.readingTrackings {
            readingList = readingList.adding(readingTracking) as NSSet
            bookInfoEntity.readingTrackings = readingList
        } else {
            bookInfoEntity.readingTrackings = [readingTracking]
        }
        
        do {
            try context.save()
            completion(tracking)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func updateReadingTracking(_ tracking: ReadingTracking, of userId: String?, newPage: Int) {
        guard let id = tracking.id else { return }
        guard let readingTracking = fetchReadingTracking(with: id) else { return }
        readingTracking.readDate = tracking.readDate
        readingTracking.readPage = Int32(newPage)
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    private func fetchReadingTracking(with id: UUID) -> ReadingTrackingEntity? {
        let request: NSFetchRequest<ReadingTrackingEntity>
        request = ReadingTrackingEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let objects = try context.fetch(request)
            return objects.first
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
