//
//  BookWishlistView.swift
//  ReadLog
//
//  Created by 유석원 on 12/11/23.
//

import SwiftUI
import CoreData

protocol AddWishListDelegate: AnyObject {
    func addWishList(_ bookInfo: BookInfo)
}

protocol RemoveWishListDelegate: AnyObject {
    func removeWishList(_ bookInfo: BookInfo)
}

struct BookWishlistView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var tab: Int
    @State private var dbBookData: [BookInfo]?
    private let fetchBookListUseCase: FetchBookListUseCase
    
    init(tab: Binding<Int>, fetchBookListUseCase: FetchBookListUseCase = FetchBookListUseCaseImpl()) {
        self._tab = tab
        self.fetchBookListUseCase = fetchBookListUseCase
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    header
                    if let dbBookData, !dbBookData.isEmpty {
                        ScrollView {
                            LazyVStack {
                                ForEach(dbBookData) { book in
                                    NavigationLink(destination: BookInfoView(tab: $tab, bookInfo: book).navigationBarBackButtonHidden(true)) {
                                        BookProfileContainer(bookInfo: book)
                                    }
                                }
                            }
                        }
                    } else {
                        Spacer()
                        Text("아직 찜 목록에 아무 것도 없어요")
                            .display(.secondary)
                    }
                    Spacer()
                }
            }
        }.onAppear {
            fetchBookListUseCase.wishBooks(of: nil) { bookList in
                dbBookData = bookList
            }
        }
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

