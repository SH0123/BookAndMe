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
    var progressPercentage: Double {
        Double(lastPageRead) / Double(totalBookPages)
    }
    private var viewContext: NSManagedObjectContext
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
    
    func addDailyProgress(newPageRead: Int, bookInfo: BookInfo) {
        guard let isbn = bookInfo.isbn else { return }
        fetchAllReadingTrackingList(isbn: isbn) { [weak self] readingTrackingList in
            if let index = readingTrackingList.firstIndex(where: { Date.yyyyMdFormatter.string(from: $0.readDate!) == Date.yyyyMdFormatter.string(from: Date()) }){
                self?.updateReadingTrackingUseCase.execute(readingTrackingList[index], of: nil, newPage: newPageRead)
            }
            else {
                self?.addTodayReadingTracking(page: newPageRead, bookInfo: bookInfo)
            }
            self?.lastPageRead = newPageRead
        }
    }
    
    func setTotalBookPages(isbn: String, page: Int) {
        fetchAllReadingTrackingList(isbn: isbn) { [weak self] readingTrackingList in
            if let lastReading = readingTrackingList.first {
                self?.lastPageRead = Int(lastReading.readPage)
            }
            self?.totalBookPages = page
        }
    }
}

private extension ReadingTrackerViewModel {
    // 완독시에 ReadingTracking 모두 지우기? 아니면 과거 읽었던 기록들 유지하면서 n회차에 읽은 시작날짜와 끝낸 날짜 추적 가능한가
    // 또한 최근의 reading tracking을 불러와서 독서 진행률을 나타내기 때문에 완독시에 reading tracking 모두 지울거 아니면 reading tracking을 0으로 만들어줘야함
    func fetchAllReadingTrackingList(isbn: String, _ completion: @escaping ([ReadingTracking])->Void) {
        fetchReadingTrackingUseCase.execute(with: isbn,
                                            of: nil) { readingTrackingList in
            completion(readingTrackingList)
        }
    }
    
    func addTodayReadingTracking(page: Int, bookInfo: BookInfo) {
        let newReadingTracking = ReadingTracking(id: UUID(), readDate: Date(), readPage: page)
        addReadingTrackingUseCase.execute(newReadingTracking, to: bookInfo, of: nil)
    }
}
