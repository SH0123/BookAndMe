//
//  DailyProgress.swift
//  ReadLog
//
//  Created by sanghyo on 12/7/23.
//

import Foundation

struct DailyProgress: Identifiable {
    let id = UUID()
    var day: String
    var pagesRead: Int
}
