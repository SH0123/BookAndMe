//
//  CoreDataEntity+Mapping.swift
//  ReadLog
//
//  Created by sanghyo on 3/6/24.
//

import UIKit

extension BookInfoEntity {
    func toDomain() -> BookInfo {
        return .init(
            id: Int(id),
            author: author ?? "",
            bookDescription: bookDescription ?? "",
            image: UIImage(data: image ?? Data()),
            isbn: isbn,
            link: link ?? "",
            readingStatus: readingStatus,
            repeatTime: Int(repeatTime),
            page: Int(page),
            pinned: pinned,
            publisher: publisher ?? "",
            title: title ?? "제목 없음",
            wish: wish,
            notes: bookNotes?.allObjects.map { ($0 as! BookNoteEntity).toDomain() } ?? [],
            trackings: readingTrackings?.allObjects.map { ($0 as! ReadingTrackingEntity).toDomain() } ?? [],
            readbooks: readBooks?.allObjects.map { ($0 as! ReadBookEntity).toDomain() } ?? []
        )
    }
}

extension BookNoteEntity {
    func toDomain() -> BookNote {
        return .init(id: id,
                     date: date,
                     label: Int(label),
                     content: content)
    }
}

extension ReadBookEntity {
    func toDomain() -> ReadBook {
        return .init(id: id,
                     startDate: startDate,
                     endDate: endDate)
    }
}

extension ReadingTrackingEntity {
    func toDomain() -> ReadingTracking {
        return .init(id: id,
                     readDate: readDate,
                     readPage: Int(readPage))
    }
}
