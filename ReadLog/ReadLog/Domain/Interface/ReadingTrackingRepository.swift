//
//  ReadingTrackingRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/6/24.
//

import Foundation

protocol ReadingTrackingRepository {
    func fetchReadingTrackingList(with isbn: String) -> [ReadingTracking]
    func addReadingTracking(_ tracking: ReadingTracking, to: BookInfo)
}
