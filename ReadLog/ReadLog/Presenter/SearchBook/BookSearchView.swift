//
//  BookSearchView.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct BookSearchView: View {
    @State private var searchText = ""
    
    @State var bookTitle = "책 제목"
    @State var bookAuthor = "작가"
    @State var bookPublisher = "출판사"
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    SearchBar(text: $searchText)
                    
                    // useless?
//                    Button {
//                        print("Search book by book title")
//                    } label: {
//                        Image(systemName: "magnifyingglass").tint(Color.secondary)
//                    }.padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 8))
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                
                ScrollView {
                    LazyVStack {
                        BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher)
                        BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher)
                        BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher)
                        BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher)
                    }
                }
                Spacer()
                
                
            }
            .navigationTitle("책 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Use barcode search")
                    } label: {
                        Image(systemName: "barcode.viewfinder").tint(Color.black)
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    BookSearchView()
}
