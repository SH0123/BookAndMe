//
//  BookShelfView.swift
//  ReadLog
//
//  Created by sanghyo on 11/27/23.
//

import SwiftUI

struct BookShelfView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest (sortDescriptors:
                    [NSSortDescriptor(keyPath: \ReadList.enddate, ascending: false)], predicate:  NSPredicate(format: "recent == true" ),
        animation: .default)
    private var fetchedBookList: FetchedResults<ReadList>
    private let bookCountInRow: Int = 3
    private var interpolatedBookList: [BookInfo?] {
        get {
            return interpolateBookList(fetchedBookList)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                VStack(spacing: 40) {
                    header
                    List {
                        ForEach(0..<interpolatedBookList.count/bookCountInRow, id: \.self) {idx in
                            BookShelfCell(renderedBook: dataForRow(idx: idx))
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        
        .toolbar(.hidden)
    }
}

private extension BookShelfView {
    
    var header: some View {
        HStack {
            Spacer()
            Text("읽은 책 목록")
                .display(Color.black)
            Spacer()
        }
        .tint(.black)
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
    }
    
    func interpolateBookList(_ readList: FetchedResults<ReadList>) -> [BookInfo?] {
        let bookCount = readList.count
        let addBookCount = (bookCountInRow - bookCount % bookCountInRow) % bookCountInRow
        let nilArray: [BookInfo?] = Array<BookInfo?>(repeating: nil, count: addBookCount)
        let bookList = readList.map {readRecord in
            return readRecord.book }
        return bookList + nilArray
    }
    
    func dataForRow(idx: Int) -> [BookInfo?] {
        Array(interpolatedBookList[idx*bookCountInRow..<idx*bookCountInRow+3])
    }
}

#Preview {
    BookShelfView().environment(\.managedObjectContext,
            PersistenceController.preview.container.viewContext)
}
