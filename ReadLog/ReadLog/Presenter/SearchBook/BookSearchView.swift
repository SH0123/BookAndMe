//
//  BookSearchView.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct BookSearchView: View {
    @State private var searchText = ""
    
    @State var isShowingScanner = false
    
    @State var keywordSearchMode = true
    
    @State var isAPIRequestInProgress = false
    
    @StateObject private var viewModel = PaginationViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                HStack {
                    SearchBar(text: $searchText, viewModel: viewModel)
                    
                    Button {
                        print("Search book by book title")
                        
                        viewModel.clear()
                        viewModel.setKeyword(keyword: searchText)
                        viewModel.searchData()
                        
                        // hide keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                    } label: {
                        Image(systemName: "magnifyingglass").tint(Color.secondary)
                    }
                    .disabled(searchText.isEmpty)
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 8))
                        
                    
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                
                if viewModel.results.isEmpty {
                    Spacer()
                    Text("검색을 통해 책을 찾아보세요")
                        .display(.secondary)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.results) { book in
                                NavigationLink(destination: BookInfoView(bookInfo: book)) {
                                    BookProfileContainer(bookInfo: book)
                                }
                                .onAppear {
                                    if viewModel.isKeywordSearchMode() && book.id == viewModel.results.last?.id {
                                        viewModel.searchData()
                                    }
                                }
                            }
                        }
                        
                    }
                }
                Spacer()
            }
            .background(Color("backgroundColor"))
            .navigationTitle("책 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Use barcode search")
                        self.isShowingScanner = true
                        self.isAPIRequestInProgress = false
                        self.searchText = ""
                    } label: {
                        Image(systemName: "barcode.viewfinder").tint(Color.black)
                    }
                    .fullScreenCover(isPresented: $isShowingScanner) {
                        NavigationStack {
                            VStack {
                                ISBNScannerView(isScanning: $isShowingScanner, didFindCode: { code in
                                    guard !isAPIRequestInProgress else { return }
                                    isAPIRequestInProgress = true
                                    
                                    print("scanned code: \(code)")
                                    
                                    viewModel.isbnSearchData(isbn: code) { success in
                                        isAPIRequestInProgress = false
                                    }
                                }, dismissCover: {
                                    self.isShowingScanner = false
                                })
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
