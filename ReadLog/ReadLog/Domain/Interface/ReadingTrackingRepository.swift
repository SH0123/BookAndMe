//
//  ReadingTrackingRepository.swift
//  ReadLog
//
//  Created by sanghyo on 3/6/24.
//

import Foundation

protocol ReadingTrackingRepository {
    func fetchReadingTrackingList(with isbn: String, of userId: String?, _ completion: @escaping ([ReadingTracking])->Void)
    func addReadingTracking(_ tracking: ReadingTracking, to bookInfo: BookInfo, of userId: String?)
    func updateReadingTracking(_ tracking: ReadingTracking, of userId: String?, newPage: Int)
}
