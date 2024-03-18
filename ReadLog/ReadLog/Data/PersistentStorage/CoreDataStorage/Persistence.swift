//
//  Persistence.swift
//  ReadLog
//
//  Created by 김현수 on 2023/11/16.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataStorage")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
}

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // book1
        let newBook1 = BookInfoEntity(context: viewContext)
        newBook1.isbn = "newBook1"
        newBook1.author = "Kim"
        newBook1.readBooks = nil
        if let bookCoverImage = UIImage(named: "bookExample"), let imageData = bookCoverImage.pngData() {
                  newBook1.image = imageData
              }
        
        // book2
        let newBook2 = BookInfoEntity(context: viewContext)
        newBook2.title = "title2"
        newBook2.isbn = "newBook2"
        newBook2.author = "Kim2"
        newBook2.readBooks = nil
        newBook2.readingTrackings = nil
        
        // book3
        let newBook3 = BookInfoEntity(context: viewContext)
        newBook3.isbn = "newBook3"
        newBook3.author = "Kim"
        newBook3.readBooks = nil
        if let bookCoverImage = UIImage(named: "bookExample"), let imageData = bookCoverImage.pngData() {
                newBook3.image = imageData
            }
        
        // add book1 to reading List
        let readingList1 = ReadingTrackingEntity(context: viewContext)
        readingList1.id = UUID()
        readingList1.readPage = 20
        readingList1.readDate = Date()
        
        readingList1.bookInfo = newBook1
        newBook1.readingTrackings = [readingList1]
        
        // add book2 to reading List
        let readingList2 = ReadingTrackingEntity(context: viewContext)
        readingList2.id = UUID()
        readingList2.readPage = 32
        readingList2.readDate = Date()
        
        readingList2.bookInfo = newBook2
        newBook2.readingTrackings = [readingList2]
        
        // Reading Tracker Data
        let readingList3 = ReadingTrackingEntity(context: viewContext)
        readingList3.id = UUID()
        readingList3.readPage = 50
        readingList3.readDate = Date.yyyyMdFormatter.date(from: "2023년 12월 4일")
        
        readingList3.bookInfo = newBook3
        
        let readingList4 = ReadingTrackingEntity(context: viewContext)
        readingList4.id = UUID()
        readingList4.readPage = 70
        readingList4.readDate = Date.yyyyMdFormatter.date(from: "2023년 12월 5일")
        
        readingList4.bookInfo = newBook3
        
        let readingList5 = ReadingTrackingEntity(context: viewContext)
        readingList4.id = UUID()
        readingList4.readPage = 90
        readingList4.readDate = Date.yyyyMdFormatter.date(from: "2023년 12월 5일")
        
        readingList4.bookInfo = newBook3
        
        let readingList6 = ReadingTrackingEntity(context: viewContext)
        readingList5.id = UUID()
        readingList5.readPage = 190
        readingList5.readDate = Date.yyyyMdFormatter.date(from: "2023년 12월 7일")
        
        readingList5.bookInfo = newBook3
        newBook3.readingTrackings = [readingList3, readingList4, readingList5, readingList6]
        
        // ReadList
        let readList1 = ReadBookEntity(context: viewContext)
        readList1.id = UUID()
        readList1.bookInfo = newBook1
        readList1.startDate = nil
        readList1.endDate = nil
        
        let readList2 = ReadBookEntity(context: viewContext)
        readList2.id = UUID()
        readList2.bookInfo = newBook3
        readList2.startDate = nil
        readList2.endDate = nil
        
        let readList3 = ReadBookEntity(context: viewContext)
        readList3.id = UUID()
        readList3.bookInfo = newBook1
        readList3.startDate = nil
        readList3.endDate = nil
        
        let readList4 = ReadBookEntity(context: viewContext)
        readList4.id = UUID()
        readList4.bookInfo = newBook3
        readList4.startDate = nil
        readList4.endDate = nil
        
        let readList5 = ReadBookEntity(context: viewContext)
        readList5.id = UUID()
        readList5.bookInfo = newBook1
        readList5.startDate = nil
        readList5.endDate = nil
        
        let readList6 = ReadBookEntity(context: viewContext)
        readList6.id = UUID()
        readList6.bookInfo = newBook3
        readList6.startDate = nil
        readList6.endDate = nil
        
        let readList7 = ReadBookEntity(context: viewContext)
        readList7.id = UUID()
        readList7.bookInfo = newBook1
        readList7.startDate = nil
        readList7.endDate = nil
        
        let readList8 = ReadBookEntity(context: viewContext)
        readList8.id = UUID()
        readList8.bookInfo = newBook3
        readList8.startDate = nil
        readList8.endDate = nil
        
        let readList9 = ReadBookEntity(context: viewContext)
        readList9.id = UUID()
        readList9.bookInfo = newBook1
        readList9.startDate = nil
        readList9.endDate = nil
        
        let readList10 = ReadBookEntity(context: viewContext)
        readList10.id = UUID()
        readList10.bookInfo = newBook3
        readList10.startDate = nil
        readList10.endDate = nil
        
        
        let readList11 = ReadBookEntity(context: viewContext)
        readList11.id = UUID()
        readList11.bookInfo = newBook1
        readList11.startDate = nil
        readList11.endDate = nil
        
        let readList12 = ReadBookEntity(context: viewContext)
        readList12.id = UUID()
        readList12.bookInfo = newBook3
        readList12.startDate = nil
        readList12.endDate = nil
        
        
        let readList13 = ReadBookEntity(context: viewContext)
        readList13.id = UUID()
        readList13.bookInfo = newBook1
        readList13.startDate = nil
        readList13.endDate = nil
        
        let readList14 = ReadBookEntity(context: viewContext)
        readList14.id = UUID()
        readList14.bookInfo = newBook3
        readList14.startDate = nil
        readList14.endDate = nil
        
        
        newBook1.readBooks = [readList1, readList3, readList5, readList7, readList9, readList11, readList13]
        newBook3.readBooks = [readList2, readList4, readList6, readList8, readList10, readList12, readList14]
        
        // log
        let newLog2 = BookNoteEntity(context: viewContext)
        newLog2.content = "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."
        newLog2.bookInfo = newBook2
        newLog2.date = Date()
        newBook2.bookNotes = [newLog2]
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

}
