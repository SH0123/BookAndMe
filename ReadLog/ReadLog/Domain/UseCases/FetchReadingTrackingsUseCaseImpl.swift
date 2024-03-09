//
//  FetchReadingTrackingsUseCaseImpl.swift
//  ReadLog
//
//  Created by sanghyo on 3/8/24.
//

import Foundation

protocol FetchReadingTrackingsUseCase {
    func execute(with isbn: String, of userId: String?, _ completion: @escaping ([ReadingTracking]) -> Void)
}

final class FetchReadingTrackingsUseCaseImpl: FetchReadingTrackingsUseCase {
    private let readingTrackingRepository: ReadingTrackingRepository
    
    init(readingTrackingRepository: ReadingTrackingRepository = ReadingTrackingCoreDataRepository.shared) {
        self.readingTrackingRepository = readingTrackingRepository
    }
    
    func execute(with isbn: String, of userId: String?, _ completion: @escaping ([ReadingTracking]) -> Void) {
        readingTrackingRepository.fetchReadingTrackingList(with: isbn,
                                                           of: userId) { readingTrackingList in
            completion(readingTrackingList)
        }
    }
    
    
}
