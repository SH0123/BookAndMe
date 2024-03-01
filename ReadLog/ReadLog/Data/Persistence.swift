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
        
        // book2
        let newBook2 = BookInfo(context: viewContext)
        newBook2.title = "title2"
        newBook2.isbn = "newBook2"
        newBook2.author = "Kim2"
        newBook2.readList = nil
        newBook2.readingList = nil
        
        // book3
        let newBook3 = BookInfo(context: viewContext)
        newBook3.isbn = "newBook3"
        newBook3.author = "Kim"
        newBook3.readList = nil
        if let bookCoverImage = UIImage(named: "bookExample"), let imageData = bookCoverImage.pngData() {
                newBook3.image = imageData
            }
        
        // add book1 to reading List
        let readingList1 = ReadingList(context: viewContext)
        readingList1.id = UUID()
        readingList1.readpage = 20
        readingList1.readtime = Date()
        readingList1.recent = true
        readingList1.pinned = false
        
        readingList1.book = newBook1
        newBook1.readingList = [readingList1]
        
        // add book2 to reading List
        let readingList2 = ReadingList(context: viewContext)
        readingList2.id = UUID()
        readingList2.readpage = 32
        readingList2.readtime = Date()
        readingList2.recent = true
        readingList2.pinned = false
        
        readingList2.book = newBook2
        newBook2.readingList = [readingList2]
        
        // Reading Tracker Data
        let readingList3 = ReadingList(context: viewContext)
        readingList3.id = UUID()
        readingList3.readpage = 50
        readingList3.readtime = Date.yyyyMdFormatter.date(from: "2023년 12월 4일")
        readingList3.recent = false
        readingList3.pinned = false
        
        readingList3.book = newBook3
        
        let readingList4 = ReadingList(context: viewContext)
        readingList4.id = UUID()
        readingList4.readpage = 70
        readingList4.readtime = Date.yyyyMdFormatter.date(from: "2023년 12월 5일")
        readingList4.recent = false
        readingList4.pinned = false
        
        readingList4.book = newBook3
        
        let readingList5 = ReadingList(context: viewContext)
        readingList4.id = UUID()
        readingList4.readpage = 90
        readingList4.readtime = Date.yyyyMdFormatter.date(from: "2023년 12월 5일")
        readingList4.recent = false
        readingList4.pinned = false
        
        readingList4.book = newBook3
        
        let readingList6 = ReadingList(context: viewContext)
        readingList5.id = UUID()
        readingList5.readpage = 190
        readingList5.readtime = Date.yyyyMdFormatter.date(from: "2023년 12월 7일")
        readingList5.recent = false
        readingList5.pinned = false
        
        readingList5.book = newBook3
        newBook3.readingList = [readingList3, readingList4, readingList5, readingList6]
        
        // ReadList
        let readList1 = ReadList(context: viewContext)
        readList1.id = UUID()
        readList1.book = newBook1
        readList1.recent = true
        readList1.startdate = nil
        readList1.enddate = nil
        
        let readList2 = ReadList(context: viewContext)
        readList2.id = UUID()
        readList2.book = newBook3
        readList2.recent = true
        readList2.startdate = nil
        readList2.enddate = nil
        
        let readList3 = ReadList(context: viewContext)
        readList3.id = UUID()
        readList3.book = newBook1
        readList3.recent = true
        readList3.startdate = nil
        readList3.enddate = nil
        
        let readList4 = ReadList(context: viewContext)
        readList4.id = UUID()
        readList4.book = newBook3
        readList4.recent = true
        readList4.startdate = nil
        readList4.enddate = nil
        
        let readList5 = ReadList(context: viewContext)
        readList5.id = UUID()
        readList5.book = newBook1
        readList5.recent = true
        readList5.startdate = nil
        readList5.enddate = nil
        
        let readList6 = ReadList(context: viewContext)
        readList6.id = UUID()
        readList6.book = newBook3
        readList6.recent = true
        readList6.startdate = nil
        readList6.enddate = nil
        
        let readList7 = ReadList(context: viewContext)
        readList7.id = UUID()
        readList7.book = newBook1
        readList7.recent = true
        readList7.startdate = nil
        readList7.enddate = nil
        
        let readList8 = ReadList(context: viewContext)
        readList8.id = UUID()
        readList8.book = newBook3
        readList8.recent = true
        readList8.startdate = nil
        readList8.enddate = nil
        
        let readList9 = ReadList(context: viewContext)
        readList9.id = UUID()
        readList9.book = newBook1
        readList9.recent = true
        readList9.startdate = nil
        readList9.enddate = nil
        
        let readList10 = ReadList(context: viewContext)
        readList10.id = UUID()
        readList10.book = newBook3
        readList10.recent = true
        readList10.startdate = nil
        readList10.enddate = nil
        
        
        let readList11 = ReadList(context: viewContext)
        readList11.id = UUID()
        readList11.book = newBook1
        readList11.recent = true
        readList11.startdate = nil
        readList11.enddate = nil
        
        let readList12 = ReadList(context: viewContext)
        readList12.id = UUID()
        readList12.book = newBook3
        readList12.recent = true
        readList12.startdate = nil
        readList12.enddate = nil
        
        
        let readList13 = ReadList(context: viewContext)
        readList13.id = UUID()
        readList13.book = newBook1
        readList13.recent = true
        readList13.startdate = nil
        readList13.enddate = nil
        
        let readList14 = ReadList(context: viewContext)
        readList14.id = UUID()
        readList14.book = newBook3
        readList14.recent = true
        readList14.startdate = nil
        readList14.enddate = nil
        
        
        newBook1.readList = [readList1, readList3, readList5, readList7, readList9, readList11, readList13]
        newBook3.readList = [readList2, readList4, readList6, readList8, readList10, readList12, readList14]
        
        // log
        let newLog2 = ReadLog(context: viewContext)
        newLog2.log = "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."
        newLog2.book = newBook2
        newLog2.date = Date()
        newBook2.readLog = [newLog2]
        
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

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Model")
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
