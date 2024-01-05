//
//  ReadingTrackerViewModel.swift
//  ReadLog
//
//  Created by sanghyo on 12/7/23.
//

import Foundation
import CoreData


final class ReadingTrackerViewModel: ObservableObject {
    @Published var totalBookPages = 400 // total number of pages in book
    @Published var lastPageRead = 0 //Store the last page read
    @Published var dailyProgress: [DailyProgress] = [
        DailyProgress(day: "Mon", pagesRead: 0),
        DailyProgress(day: "Tue", pagesRead: 0),
        DailyProgress(day: "Wed", pagesRead: 0),
        DailyProgress(day: "Thu", pagesRead: 0),
        DailyProgress(day: "Fri", pagesRead: 0),
        DailyProgress(day: "Sat", pagesRead: 0),
        DailyProgress(day: "Sun", pagesRead: 0),
    ]
    var progressPercentage: Double {
        Double(lastPageRead) / Double(totalBookPages)
    }
    private var viewContext: NSManagedObjectContext
    private var pinned: Bool = false
     
    init(context: NSManagedObjectContext) {
        self.viewContext = PersistenceController.shared.container.viewContext
     }
    
    func setDailyProgress(isbn: String) {
        var lastPage = 0
        if let lastWeekReadingList = fetchLastWeekReadingData(isbn: isbn) {
            lastPage = Int(lastWeekReadingList.readpage)
        }
        let thisWeekReadingList = fetchThisWeekReadingData(isbn: isbn)
        
        for idx in 0..<thisWeekReadingList.count {
            let day = thisWeekReadingList[idx].readtime!
            let readPage = Int(thisWeekReadingList[idx].readpage)
            
            if let i = dailyProgress.firstIndex(where: { $0.day == getCurrentDay(date: day) }) {
                let pagesReadThatDay = readPage - lastPage
                if pagesReadThatDay > 0 {
                    dailyProgress[i].pagesRead += pagesReadThatDay
                }
            }
            lastPage = readPage
        }
        lastPageRead = lastPage
    }
    
    func addDailyProgress(newPageRead: Int, bookInfo: BookInfo) {
        // set last data recent = false
        let readingList = fetchAllReadingData(isbn: bookInfo.isbn!)
        for idx in 0..<readingList.count {
            updateRecentValue(entity: readingList[idx])
        }
        
        if let lastReading = readingList.last {
            self.pinned = lastReading.pinned
        }
//        
//        let day = getCurrentDay(date: Date())
//        if let index = dailyProgress.firstIndex(where: { $0.day == day }) {
//            let pagesReadToday = newPageRead - lastPageRead
//            if pagesReadToday > 0 {
//                dailyProgress[index].pagesRead += pagesReadToday
//                addTodayBookPage(page: newPageRead, bookInfo: bookInfo)
//            }
//            lastPageRead = newPageRead
//        }
        addTodayBookPage(page: newPageRead, bookInfo: bookInfo)
        lastPageRead = newPageRead
    }
    
    func setTotalBookPages(isbn: String, page: Int) {
        let readingList = fetchAllReadingData(isbn: isbn)
        if let lastReading = readingList.last {
            lastPageRead = Int(lastReading.readpage)
        }
        totalBookPages = page
    }
    
    private func getCurrentDay(date: Date) -> String {
        return Date.dayOfWeekFormatter.string(from: date)
    }
    
    private func makeDayMidnight(date: Date) -> Date {
        let componenents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let targetComponents = DateComponents(year: componenents.year!, month: componenents.month!, day: componenents.day!)
        return Calendar.current.date(from: targetComponents)!
    }
}

private extension ReadingTrackerViewModel {
    func fetchThisWeekReadingData(isbn: String) -> [ReadingList] {
        let today: Date = Date()
        let monTodayDiff: Int = (5 + Calendar.current.dateComponents([.weekday], from: today).weekday!) % 7
        let monday: Date = makeDayMidnight(date: Calendar.current.date(byAdding:.day, value: -1*monTodayDiff, to: today)!)
        
        let fetchRequest: NSFetchRequest<ReadingList>
        
        fetchRequest = ReadingList.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ReadingList.readtime, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "book.isbn LIKE %@ && readtime >= %@ ",isbn,  monday as NSDate)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }

    func fetchLastWeekReadingData(isbn: String) -> ReadingList? {
        let today: Date = Date()
        let monTodayDiff: Int = (5 + Calendar.current.dateComponents([.weekday], from: today).weekday!) % 7
        let monday: Date = makeDayMidnight(date: Calendar.current.date(byAdding:.day, value: -1*monTodayDiff, to: today)!)
        let fetchRequest: NSFetchRequest<ReadingList>
        
        fetchRequest = ReadingList.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ReadingList.readtime, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "book.isbn LIKE %@ && readtime < %@ ",isbn, monday as NSDate)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects.first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func fetchAllReadingData(isbn: String) -> [ReadingList] {
        let fetchRequest: NSFetchRequest<ReadingList>
        
        fetchRequest = ReadingList.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ReadingList.readtime, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "book.isbn LIKE %@",isbn)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func updateRecentValue(entity: ReadingList) {
        entity.recent = false
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    
    func addTodayBookPage(page: Int, bookInfo: BookInfo) {
        let readingPage = ReadingList(context: viewContext)
        readingPage.id = UUID()
        readingPage.readpage = Int32(page)
        readingPage.pinned = pinned
        readingPage.readtime = Date()
        readingPage.recent = true
        readingPage.book = bookInfo
        
        if var readingList = bookInfo.readingList {
            readingList = readingList.adding(readingPage) as NSSet
            bookInfo.readingList = readingList
        } else {
            bookInfo.readingList = [readingPage]
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
}
