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

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // book1
        let newBook1 = BookInfo(context: viewContext)
        newBook1.isbn = "newBook1"
        newBook1.author = "Kim"
        newBook1.readList = nil
        if let bookCoverImage = UIImage(named: "bookExample"), let imageData = bookCoverImage.pngData() {
                newBook1.image = imageData
            }
        
        // log1
//        let newLog1 = ReadLog(context: viewContext)
//        newLog1.log = "loglog11111"
//        newLog1.book = newBook1
//        newLog1.date = Date()
//        
//        newBook1.readLog = [newLog1]
        
        // add book1 to reading List
        let readingList1 = ReadingList(context: viewContext)
        readingList1.id = 1
        readingList1.readpage = 20
        readingList1.readtime = Date()
        readingList1.recent = true
        readingList1.pinned = false
        
        readingList1.book = newBook1
        newBook1.readingList = [readingList1]
        
        
        // book2
        let newBook2 = BookInfo(context: viewContext)
        newBook2.isbn = "newBook2"
        newBook2.author = "Kim2"
        newBook2.readList = nil
        newBook2.readingList = nil
        
        // log2
        let newLog2 = ReadLog(context: viewContext)
        newLog2.log = "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."
        newLog2.book = newBook2
        newLog2.date = Date()
        
        newBook2.readLog = [newLog2]
        
        // add book2 to reading List
        let readingList2 = ReadingList(context: viewContext)
        readingList2.id = 2
        readingList2.readpage = 32
        readingList2.readtime = Date()
        readingList2.recent = true
        readingList2.pinned = false
        
        readingList2.book = newBook2
        newBook2.readingList = [readingList2]
        
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

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
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
