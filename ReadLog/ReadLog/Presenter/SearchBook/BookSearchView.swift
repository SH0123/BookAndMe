//
//  BookSearchView.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct BookSearchView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    
    @State var isShowingScanner = false
    
    @State var keywordSearchMode = true
    
    @State var isAPIRequestInProgress = false
    
    @StateObject private var viewModel = PaginationViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        HStack {
                            Spacer()
                            Text("책 검색")
                                .display(Color.black)
                            Spacer()
                            
                        }
                        .tint(.black)
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
                        
                        HStack {
                            Button(action:{
                                self.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(Color.primary)
                            }
                            
                            Spacer()
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
                                    ZStack {
                                        Color.backgroundColor
                                            .ignoresSafeArea()
                                        VStack {
                                            ZStack {
                                                HStack {
                                                    Spacer()
                                                    Text("바코드 스캔")
                                                        .display(Color.black)
                                                    Spacer()
                                                }
                                                .tint(.black)
                                                .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
                                                
                                                HStack {
                                                    Button(role: .cancel) {
                                                        self.isShowingScanner = false
                                                    } label: {
                                                        Image(systemName: "xmark")
                                                            .foregroundColor(.black)
                                                    }
                                                    Spacer()
                                                }
                                                .padding(.leading, 16)
                                                .padding(.top, 4)
                                            }
                                            
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
                                        
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                    }
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
                                    NavigationLink(destination: BookInfoView(bookInfo: book).navigationBarBackButtonHidden(true)) {
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
            }

        }
    }
}

#Preview {
    BookSearchView()
}
