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
    @State var bookNthCycle = 0
    
    @State var isShowingScanner = false
    @State var scannedCode: String?
    
    var body: some View {
        
        NavigationStack {
            VStack {
                HStack {
                    SearchBar(text: $searchText)
                    
                    
                    Button {
                        print("Search book by book title")
                    } label: {
                        Image(systemName: "magnifyingglass").tint(Color.secondary)
                    }.padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 8))
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                
                ScrollView {
                    LazyVStack {
                        NavigationLink(destination: BookInfoView()) {
                            BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher, bookNthCycle: $bookNthCycle)
                        }
                        .foregroundColor(.black)
                        
                        NavigationLink(destination: BookInfoView()) {
                            BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher, bookNthCycle: $bookNthCycle)
                        }
                        .foregroundColor(.black)
                        
                        NavigationLink(destination: BookInfoView()) {
                            BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher, bookNthCycle: $bookNthCycle)
                        }
                        .foregroundColor(.black)
                        
                        NavigationLink(destination: BookInfoView()) {
                            BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher, bookNthCycle: $bookNthCycle)
                        }
                        .foregroundColor(.black)
                        
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                }
                Spacer()
                
                
            }
            .navigationTitle("책 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Use barcode search")
                        self.isShowingScanner = true
                    } label: {
                        Image(systemName: "barcode.viewfinder").tint(Color.black)
                    }
                    .fullScreenCover(isPresented: $isShowingScanner) {
                        NavigationStack {
                            VStack {
                                ISBNScannerView(isScanning: $isShowingScanner) { code in
                                    self.scannedCode = code
                                    // temporarily show ISBN data on search bar
                                    searchText = scannedCode!
                                    print("scanned code: \(scannedCode!)")
                                    self.isShowingScanner = false
                                }
                                .ignoresSafeArea(.all)
                            }
                            .navigationTitle("바코드 스캔")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbarBackground(Color.backgroundColor, for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button(role: .cancel) {
                                        self.isShowingScanner = false
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
        
        
    }
    
 
}

#Preview {
    BookSearchView()
}
