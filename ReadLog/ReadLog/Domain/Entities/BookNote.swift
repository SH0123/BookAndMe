//
//  Memo.swift
//  ReadLog
//
//  Created by sanghyo on 12/6/23.
//

import Foundation

struct BookNote: Identifiable {
    let id: UUID
    let date: Date
    let label: String
    let content: String
    let book: BookInfo
}
