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
    private let fetchReadingTrackingUseCase: FetchReadingTrackingsUseCase
    private let addReadingTrackingUseCase: AddReadingTrackingUseCase
    private let updateReadingTrackingUseCase: UpdateReadingTrackingUseCase
     
    init(context: NSManagedObjectContext,
         fetchReadingTrackingUseCase: FetchReadingTrackingsUseCase = FetchReadingTrackingsUseCaseImpl(),
         addReadingTrackingUseCase: AddReadingTrackingUseCase = AddReadingTrackingUseCaseImpl(),
         updateReadingTrackingUseCaes: UpdateReadingTrackingUseCase = UpdateReadingTrackingUseCaseImpl()) {
        self.viewContext = PersistenceController.shared.container.viewContext
        self.fetchReadingTrackingUseCase = fetchReadingTrackingUseCase
        self.addReadingTrackingUseCase = addReadingTrackingUseCase
        self.updateReadingTrackingUseCase = updateReadingTrackingUseCaes
     }
    
    /*
    func setDailyProgress(isbn: String) {
        var lastPage = 0
        if let lastWeekReadingList = fetchLastWeekReadingData(isbn: isbn) {
            lastPage = Int(lastWeekReadingList.readPage)
        }
        let thisWeekReadingList = fetchThisWeekReadingData(isbn: isbn)
        
        for idx in 0..<thisWeekReadingList.count {
            let day = thisWeekReadingList[idx].readDate!
            let readPage = Int(thisWeekReadingList[idx].readPage)
            
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
     */
    
    func addDailyProgress(newPageRead: Int, bookInfo: BookInfo) {
        // set last data recent = false
        guard let isbn = bookInfo.isbn else { return }
        fetchAllReadingTrackingList(isbn: isbn) { [weak self] readingTrackingList in
            if let index = readingTrackingList.firstIndex(where: { Date.yyyyMdFormatter.string(from: $0.readDate!) == Date.yyyyMdFormatter.string(from: Date()) }){
                self?.updateReadingTrackingUseCase.execute(readingTrackingList[index], of: nil, newPage: newPageRead)
            }
            else {
                self?.addTodayReadingTracking(page: newPageRead, bookInfo: bookInfo)
            }
        }
    }
    
    func setTotalBookPages(isbn: String, page: Int) {
        fetchAllReadingTrackingList(isbn: isbn) { [weak self] readingTrackingList in
            if let lastReading = readingTrackingList.last {
                self?.lastPageRead = Int(lastReading.readPage)
            }
            self?.totalBookPages = page
        }
    }
    /*
    private func getCurrentDay(date: Date) -> String {
        return Date.dayOfWeekFormatter.string(from: date)
    }
    
    private func makeDayMidnight(date: Date) -> Date {
        let componenents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let targetComponents = DateComponents(year: componenents.year!, month: componenents.month!, day: componenents.day!)
        return Calendar.current.date(from: targetComponents)!
    }*/
}

private extension ReadingTrackerViewModel {
    /*
    func fetchThisWeekReadingData(isbn: String) -> [ReadingTrackingEntity] {
        let today: Date = Date()
        let monTodayDiff: Int = (5 + Calendar.current.dateComponents([.weekday], from: today).weekday!) % 7
        let monday: Date = makeDayMidnight(date: Calendar.current.date(byAdding:.day, value: -1*monTodayDiff, to: today)!)
        
        let fetchRequest: NSFetchRequest<ReadingTrackingEntity>
        
        fetchRequest = ReadingTrackingEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ReadingTrackingEntity.readDate, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "bookInfo.isbn LIKE %@ && readtime >= %@ ",isbn,  monday as NSDate)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }

    func fetchLastWeekReadingData(isbn: String) -> ReadingTrackingEntity? {
        let today: Date = Date()
        let monTodayDiff: Int = (5 + Calendar.current.dateComponents([.weekday], from: today).weekday!) % 7
        let monday: Date = makeDayMidnight(date: Calendar.current.date(byAdding:.day, value: -1*monTodayDiff, to: today)!)
        let fetchRequest: NSFetchRequest<ReadingTrackingEntity>
        
        fetchRequest = ReadingTrackingEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ReadingTrackingEntity.readDate, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "bookInfo.isbn LIKE %@ && readDate < %@ ",isbn, monday as NSDate)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects.first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }*/
    // 완독시에 ReadingTracking 모두 지우기? 아니면 과거 읽었던 기록들 유지하면서 n회차에 읽은 시작날짜와 끝낸 날짜 추적 가능한가
    func fetchAllReadingTrackingList(isbn: String, _ completion: @escaping ([ReadingTracking])->Void) {
        fetchReadingTrackingUseCase.execute(with: isbn,
                                            of: nil) { readingTrackingList in
            completion(readingTrackingList)
        }
        
    }
    
    func addTodayReadingTracking(page: Int, bookInfo: BookInfo) {
        let newReadingTracking = ReadingTracking(id: UUID(), readDate: Date(), readPage: page)
        addReadingTrackingUseCase.execute(newReadingTracking, to: bookInfo, of: nil) { [weak self] readingTracking in
            self?.lastPageRead = readingTracking.readPage
        }
    }
}
