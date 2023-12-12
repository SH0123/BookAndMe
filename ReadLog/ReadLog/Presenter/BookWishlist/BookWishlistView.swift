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
    @Binding var tab: Int
    
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
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    header
                    if dbBookData.isEmpty {
                        Spacer()
                        Text("아직 찜 목록에 아무 것도 없어요!")
                            .display(.secondary)
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(dbBookData) { item in
                                    let book = convertToBookInfo(book: item)
                                    
                                    NavigationLink(destination: BookInfoView(tab: $tab, bookInfo: book).navigationBarBackButtonHidden(true)) {
                                        BookProfileContainer(bookInfo: book)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
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

private extension BookWishlistView {
    var header: some View {
        ZStack {
            HStack {
                Spacer()
                Text("찜 목록")
                    .display(Color.black)
                Spacer()
                
            }
            .tint(.black)
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
            
            HStack {
                Spacer()
                NavigationLink(destination: BookSearchView(tab: $tab).navigationBarBackButtonHidden(true)) {
                    Image(systemName: "magnifyingglass")
                }
            }
            .padding(.trailing, 16)
        }
        
    }
}
