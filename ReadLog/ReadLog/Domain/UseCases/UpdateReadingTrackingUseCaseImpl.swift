//
//  UpdateReadingTrackingUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/8/24.
//

import Foundation

protocol UpdateReadingTrackingUseCase {
    func execute(_ tracking: ReadingTracking, of userId: String?, newPage: Int)
}

final class UpdateReadingTrackingUseCaseImpl: UpdateReadingTrackingUseCase {
    private let readingTrackingRepository: ReadingTrackingRepository
    
    init(readingTrackingRepository: ReadingTrackingRepository = ReadingTrackingCoreDataRepository.shared) {
        self.readingTrackingRepository = readingTrackingRepository
    }

    func execute(_ tracking: ReadingTracking, of userId: String?, newPage: Int) {
        readingTrackingRepository.updateReadingTracking(tracking, of: userId, newPage: newPage)
    }
    
    
}
