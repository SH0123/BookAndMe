//
//  BookWishlistView.swift
//  ReadLog
//
//  Created by 유석원 on 12/11/23.
//

import SwiftUI
import CoreData

struct BookWishlistView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \BookInfo.title, ascending: true)
        ],
        predicate: NSPredicate(format: "wish == true"),
        animation: .default
    )
    private var dbBookData: FetchedResults<BookInfo>
    
    var body: some View {
        NavigationStack {
            VStack {
                if dbBookData.isEmpty {
                    Spacer()
                    Text("아직 찜 목록에 아무 것도 없어요!")
                        .display(.secondary)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(dbBookData) { item in
                                let book = convertToBookInfo(book: item)
                                
                                NavigationLink(destination: BookInfoView(bookInfo: book)) {
                                    BookProfileContainer(bookInfo: book)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            
            .navigationTitle("찜 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: BookSearchView()) {
                        Image(systemName: "magnifyingglass")
                    }
                    .foregroundStyle(.black)
                }
            }
        }
        .background(Color("backgroundColor"))
    }
    
    func convertToBookInfo(book: FetchedResults<BookInfo>.Element) -> BookInfoData {
        return BookInfoData(
            id: Int(book.id),
            isbn: book.isbn!,
            title: book.title!,
            author: book.author!,
            description: book.bookDescription!,
            coverImage: "",
            publisher: book.publisher!,
            link: book.link!,
            itemPage: Int(book.page),
            dbImage: book.image,
            dbWish: book.wish,
            dbNthCycle: Int(book.nthCycle)
        )
    }
}

