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
    
    // later use core data instead of temporal data structure
    @State private var bookItems: [BookInfoData_Temporal] = []
    
    var body: some View {
        
        NavigationStack {
            VStack {
                HStack {
                    SearchBar(text: $searchText, fetchData: fetchData)
                    
                    Button {
                        print("Search book by book title")
                        let request = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=\(ApiKey.aladinKey)&Query=\(searchText)&QueryType=Keyword&MaxResults=10&start=1&SearchTarget=Book&output=js&Version=20131101"
                        
                        fetchData(requestUrl: request)
                        
                    } label: {
                        Image(systemName: "magnifyingglass").tint(Color.secondary)
                    }
                    .disabled(searchText.isEmpty)
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 8))
                        
                    
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                
                if bookItems.isEmpty {
                    Spacer()
                    Text("검색을 통해 책을 찾아보세요")
                        .foregroundStyle(.secondary)
                        .font(.title)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach($bookItems) { book in
                                
                                NavigationLink(destination: BookInfoView(bookInfo: book)) {
                                    BookProfileContainer(bookInfo: book)
                                }
                            }
                        }
                        
    //                    LazyVStack {
    //                        NavigationLink(destination: BookInfoView()) {
    //                            BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher, bookNthCycle: $bookNthCycle)
    //                        }
    //                        .foregroundColor(.black)
    //
    //                        NavigationLink(destination: BookInfoView()) {
    //                            BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher, bookNthCycle: $bookNthCycle)
    //                        }
    //                        .foregroundColor(.black)
    //
    //                        NavigationLink(destination: BookInfoView()) {
    //                            BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher, bookNthCycle: $bookNthCycle)
    //                        }
    //                        .foregroundColor(.black)
    //
    //                        NavigationLink(destination: BookInfoView()) {
    //                            BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher, bookNthCycle: $bookNthCycle)
    //                        }
    //                        .foregroundColor(.black)
    //
    //                    }
    //                    .padding(.vertical, 10)
    //                    .padding(.horizontal, 10)
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
                    } label: {
                        Image(systemName: "barcode.viewfinder").tint(Color.black)
                    }
                    .fullScreenCover(isPresented: $isShowingScanner) {
                        NavigationStack {
                            VStack {
                                ISBNScannerView(isScanning: $isShowingScanner) { code in
                                    self.scannedCode = code
                                    // set search text to blank
                                    searchText = ""
                                    print("scanned code: \(scannedCode!)")
                                    let request = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=\(ApiKey.aladinKey)&itemIdType=ISBN13&ItemId=\(scannedCode!)&output=js&Version=20131101&OptResult=ebookList,usedList,reviewList"
                                    
                                    fetchData(requestUrl: request)
                                    
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
    
    func fetchData(requestUrl: String) {
        guard let url = URL(string: requestUrl) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
//                let decodedData = try decoder.decode([BookInfoData_Temporal].self, from: data)
                let decodedData = try decoder.decode(APIResponse.self, from: data)
                
                DispatchQueue.main.async {
//                    self.bookItems = decodedData
                    self.bookItems = decodedData.item
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        // hide keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        task.resume()
    }
    
 
}

#Preview {
    BookSearchView()
}
