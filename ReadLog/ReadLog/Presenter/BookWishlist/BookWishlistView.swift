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
                    Text("검색을 통해 책을 찾아보세요")
                        .display(.secondary)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(dbBookData) { item in
                                let book = BookInfoData(
                                    id: Int(item.id),
                                    isbn: item.isbn!,
                                    title: item.title!,
                                    author: item.author!,
                                    description: item.bookDescription!,
                                    coverImage: "",
                                    publisher: item.publisher!,
                                    link: item.link!,
                                    itemPage: Int(item.page),
                                    dbImage: item.image!,
                                    dbWish: item.wish!,
                                    dbNthCycle: Int(item.nthCycle)
                                )
                                NavigationLink(destination: BookInfoView(bookInfo: book)) {
                                    BookProfileContainer(bookInfo: book)
                                }
                            }
                        }
                    }
                }
            }
            .background(Color("backgroundColor"))
            .navigationTitle("책 검색")
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
    }
}
