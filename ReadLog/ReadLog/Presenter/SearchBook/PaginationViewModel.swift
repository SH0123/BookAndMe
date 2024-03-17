//
//  PaginationViewModel.swift
//  ReadLog
//
//  Created by 유석원 on 11/28/23.
//

import SwiftUI

class PaginationViewModel: ObservableObject {
    @Published var results: [BookInfo] = []
    @Published private (set) var isLoading: Bool = false
    
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
        isLoading = true
        
//        let aladinFetcher = AladinManager()
//        aladinFetcher.fetchAndDecode(keyword: keyword, maxResult: 20, currentPage: currentPage) {_ in}
        // TODO: current Page update 되도록, currentPage가 max를 넘어서지 않도록 control, fetch image는 읽기 시작 눌렀을 때만 되도록 코드 확장, ISBN 용도의 코드는 따로 작성해야하나? 상속할 수 있나 생각해보기
        // TODO: 실행 잘 되는지 테스트
        currentPage += 1
        let requestUrl = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=\(ApiKey.aladinKey)&Query=\(keyword)&QueryType=Keyword&MaxResults=20&start=\(currentPage)&SearchTarget=Book&output=js&Version=20131101"

        guard let encodedUrl = requestUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        guard let url = URL(string: encodedUrl) else {
            print("not possible with \(requestUrl)")
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
                
                let decodedData = try decoder.decode(AladinJsonResponse.self, from: data)

                if decodedData.totalResults / 20 < 10 {
                    self.totalPages = (decodedData.totalResults - 1) / 20 + 1
                }
                
                DispatchQueue.main.async { [weak self] in
                    print(decodedData.item.count)
                    let filteredData = decodedData.item.filter { $0.isbn != "" }
                    let bookDataArray: [BookInfo] = filteredData.map { bookDataJsonResponse in
                        if let itemPage = bookDataJsonResponse.subInfo?.itemPage {
                            return (self?.mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse, page: itemPage))!
                        } else {
                            return (self?.mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse, page: 0))!
                        }
                    }
                    
                    self?.results.append(contentsOf: bookDataArray)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        
        
        task.resume()
        
        DispatchQueue.main.async {
            self.isFetching = false
        }
    }
    
    func mappingToBookInfo(bookDataJsonResponse: AladinJsonResponseItem, page: Int) -> BookInfo {
        // 사진 저장 안됨
        var bookInfo = BookInfo(id: String(bookDataJsonResponse.id),
                                author: bookDataJsonResponse.author,
                                bookDescription: bookDataJsonResponse.description,
                                coverImageUrl: bookDataJsonResponse.coverImage,
                                image: nil,
                                isbn: bookDataJsonResponse.isbn,
                                link: bookDataJsonResponse.link,
                                readingStatus: false,
                                repeatTime: 0,
                                page: page,
                                publisher: bookDataJsonResponse.publisher,
                                title: bookDataJsonResponse.title,
                                wish: false,
                                notes: [],
                                trackings: [],
                                readbooks: [])
        
        return bookInfo
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
                
                let decodedData = try decoder.decode(AladinJsonResponse.self, from: data)
                
                DispatchQueue.main.async { [weak self] in
                    print(decodedData.item.count)
                    
                    let bookDataArray: [BookInfo] = decodedData.item.map { bookDataJsonResponse in
                        if let itemPage = bookDataJsonResponse.subInfo?.itemPage {
                            return (self?.mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse, page: itemPage))!
                        } else {
                            return (self?.mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse, page: 0))!
                        }
                    }
                    
                    self?.results.append(contentsOf: bookDataArray)
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
