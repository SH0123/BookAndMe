//
//  CoreDataEntity+Mapping.swift
//  ReadLog
//
//  Created by sanghyo on 3/6/24.
//

import UIKit
import CoreData

//MARK: DB Entity -> Domain
extension BookInfoEntity {
    func toDomain() -> BookInfo {
        return .init(
            id: id ?? UUID().uuidString ,
            author: author ?? "",
            bookDescription: bookDescription ?? "",
            coverImageUrl: "",
            image: UIImage(data: image ?? Data()),
            isbn: isbn,
            link: link ?? "",
            readingStatus: readingStatus,
            repeatTime: Int(repeatTime),
            page: Int(page),
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

// MARK: Domain -> DB Entity
extension ReadingTracking {
    func toEntity(context: NSManagedObjectContext, bookInfoEntity: BookInfoEntity) -> ReadingTrackingEntity {
        let entity = ReadingTrackingEntity(context: context)
        entity.id = id
        entity.readDate = readDate
        entity.readPage = Int32(readPage)
        entity.bookInfo = bookInfoEntity
        
        return entity
    }
}

extension ReadBook {
    func toEntity(context: NSManagedObjectContext, bookInfoEntity: BookInfoEntity) -> ReadBookEntity {
        let entity = ReadBookEntity(context: context)
        entity.id = id
        entity.startDate = startDate
        entity.endDate = endDate
        entity.bookInfo = bookInfoEntity
        
        return entity
    }
}

extension BookNote {
    func toEntity(context: NSManagedObjectContext, bookInfoEntity: BookInfoEntity) -> BookNoteEntity {
        let entity = BookNoteEntity(context: context)
        entity.id = id
        entity.label = Int16(label)
        entity.date = date
        entity.content = content
        entity.bookInfo = bookInfoEntity
        
        return entity
    }
}
