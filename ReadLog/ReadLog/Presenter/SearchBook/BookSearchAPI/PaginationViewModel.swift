//
//  PaginationViewModel.swift
//  ReadLog
//
//  Created by 유석원 on 11/28/23.
//

import Foundation

class PaginationViewModel: ObservableObject {
    @Published var results: [BookInfoData] = []
    
    private var currentPage = 1
    
    private var totalPages = 10
    
    private var isFetching = false
    
    private var keyword = ""
    
    private var keywordSearchMode = true
    
    func isKeywordSearchMode() -> Bool {
        return keywordSearchMode
    }
    
    func setKeyword(keyword: String) {
        self.keyword = keyword
    }
    
    func clear() {
        currentPage = 1
        totalPages = 10
        isFetching = false
        keyword = ""
        results.removeAll()
    }
    
    func searchData() {
        keywordSearchMode = true
        
        guard !isFetching else { return }
        
        guard currentPage <= totalPages else { return }
        
        isFetching = true
        
        let requestUrl = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=\(ApiKey.aladinKey)&Query=\(keyword)&QueryType=Keyword&MaxResults=20&start=\(currentPage)&SearchTarget=Book&output=js&Version=20131101"
        
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
                
                let decodedData = try decoder.decode(JsonResponse.self, from: data)
                
                if decodedData.totalResults / 20 < 10 {
                    self.totalPages = (decodedData.totalResults - 1) / 20 + 1
                }
                
                DispatchQueue.main.async {
                    print(decodedData.item.count)
                    
                    let bookDataArray: [BookInfoData] = decodedData.item.map { bookData in
                        if let itemPage = bookData.subInfo?.itemPage {
                            let bookData = BookInfoData(
                                id: bookData.id,
                                isbn: bookData.isbn,
                                title: bookData.title,
                                author: bookData.author,
                                description: bookData.description,
                                coverImage: bookData.coverImage,
                                publisher: bookData.publisher,
                                link: bookData.link,
                                itemPage: itemPage,
                                dbImage: nil,
                                dbWish: false,
                                dbNthCycle: 0
                            )
                            return bookData
                        } else {
                            let bookData = BookInfoData(
                                id: bookData.id,
                                isbn: bookData.isbn,
                                title: bookData.title,
                                author: bookData.author,
                                description: bookData.description,
                                coverImage: bookData.coverImage,
                                publisher: bookData.publisher,
                                link: bookData.link,
                                itemPage: 0,
                                dbImage: nil,
                                dbWish: false,
                                dbNthCycle: 0
                            )
                            return bookData
                        }
                    }
                    
                    self.results.append(contentsOf: bookDataArray)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        currentPage += 1
        
        task.resume()
        
        DispatchQueue.main.async {
            self.isFetching = false
        }
    }
    
    func isbnSearchData(isbn: String, completion: @escaping (Bool) -> Void) {
        clear()
        keywordSearchMode = false
        totalPages = 1
        
        guard !isFetching else { return }
        
        guard currentPage <= totalPages else { return }
        
        isFetching = true
        
        let requestUrl = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=\(ApiKey.aladinKey)&itemIdType=ISBN13&ItemId=\(isbn)&output=js&Version=20131101"
        
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
                
                let decodedData = try decoder.decode(JsonResponse.self, from: data)
                
                DispatchQueue.main.async {
                    print(decodedData.item.count)
                    
                    let bookDataArray: [BookInfoData] = decodedData.item.map { bookData in
                        if let itemPage = bookData.subInfo?.itemPage {
                            let bookData = BookInfoData(
                                id: bookData.id,
                                isbn: bookData.isbn,
                                title: bookData.title,
                                author: bookData.author,
                                description: bookData.description,
                                coverImage: bookData.coverImage,
                                publisher: bookData.publisher,
                                link: bookData.link,
                                itemPage: itemPage,
                                dbImage: nil,
                                dbWish: false,
                                dbNthCycle: 0
                            )
                            return bookData
                        } else {
                            let bookData = BookInfoData(
                                id: bookData.id,
                                isbn: bookData.isbn,
                                title: bookData.title,
                                author: bookData.author,
                                description: bookData.description,
                                coverImage: bookData.coverImage,
                                publisher: bookData.publisher,
                                link: bookData.link,
                                itemPage: 0,
                                dbImage: nil,
                                dbWish: false,
                                dbNthCycle: 0
                            )
                            return bookData
                        }
                        
                        
                    }
                    
                    self.results.append(contentsOf: bookDataArray)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        currentPage += 1
        
        task.resume()
        
        DispatchQueue.main.async {
            self.isFetching = false
        }
    }
}
