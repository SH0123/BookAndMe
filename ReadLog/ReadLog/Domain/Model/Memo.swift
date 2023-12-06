//
//  Memo.swift
//  ReadLog
//
//  Created by sanghyo on 12/6/23.
//

import Foundation

struct Memo: Identifiable {
    let id: Int
    let date: Date
    let label: String
    let content: String
}

extension Memo {
    static var sampleData: [Memo] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return [
            Memo(id: 1, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 2, date:dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할."),
            Memo(id: 3, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 4, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 5, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 6, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 7, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다.")
        ]
    }
}
