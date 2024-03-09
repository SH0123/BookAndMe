//
//  AddReadingTrackingUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/8/24.
//

import Foundation

protocol AddReadingTrackingUseCase {
    func execute(_ tracking: ReadingTracking, to bookInfo: BookInfo, of userId: String?)
}

final class AddReadingTrackingUseCaseImpl: AddReadingTrackingUseCase {
    private let readingTrackingRepository: ReadingTrackingRepository
    
    init(readingTrackingRepository: ReadingTrackingRepository = ReadingTrackingCoreDataRepository.shared) {
        self.readingTrackingRepository = readingTrackingRepository
    }

    func execute(_ tracking: ReadingTracking, to bookInfo: BookInfo, of userId: String?) {
        readingTrackingRepository.addReadingTracking(tracking, to: bookInfo, of: userId)
    }
}
