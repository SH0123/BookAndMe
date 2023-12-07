//
//  BookShelfView.swift
//  ReadLog
//
//  Created by sanghyo on 11/27/23.
//

import SwiftUI

struct BookShelfView: View {
    private var bookList: [BookExample] = BookExample.mock.compactMap { $0 }
    private let bookCountInRow: Int = 3
    private var interpolatedBookList: [BookExample?] {
        get {
            interpolateBookList(bookList)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                VStack(spacing: 40) {
                    header
                    TabView {
                        ForEach(0..<3) { index in
                            VStack {
                                ForEach(0..<interpolatedBookList.count/bookCountInRow, id: \.self) {idx in
                                    BookShelfCell(renderedBook: dataForRow(idx: idx))
                                }
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 650)
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

    func interpolateBookList(_ bookList: [BookExample]) -> [BookExample?] {
        let bookCount = bookList.count
        let addBookCount = (bookCountInRow - bookCount % bookCountInRow) % bookCountInRow
        let nilArray: [BookExample?] = Array<BookExample?>(repeating: nil, count: addBookCount)
        return bookList + nilArray
    }
    
    func dataForRow(idx: Int) -> [BookExample?] {
        Array(interpolatedBookList[idx*bookCountInRow..<idx*bookCountInRow+3])
    }
}

#Preview {
    BookShelfView()
}
