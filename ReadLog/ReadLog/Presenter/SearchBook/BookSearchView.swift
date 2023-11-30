//
//  BookSearchView.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct BookSearchView: View {
    @State private var searchText = ""
    
    @State var bookNthCycle = 0
    
    @State var isShowingScanner = false
    @State var scannedCode: String?
    
    @State var keywordSearchMode = true
    
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
                        .foregroundStyle(.secondary)
                        .font(.title)
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
            .navigationTitle("책 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Use barcode search")
                        self.isShowingScanner = true
                        self.searchText = ""
                        self.scannedCode = ""
//                        viewModel.clear()
                    } label: {
                        Image(systemName: "barcode.viewfinder").tint(Color.black)
                    }
                    .fullScreenCover(isPresented: $isShowingScanner) {
                        NavigationStack {
                            VStack {
                                ISBNScannerView(isScanning: $isShowingScanner) { code in
                                    self.scannedCode = code

                                    print("scanned code: \(scannedCode!)")
                   
                                    self.isShowingScanner = false
                                    
                                    viewModel.isbnSearchData(isbn: scannedCode!)
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
