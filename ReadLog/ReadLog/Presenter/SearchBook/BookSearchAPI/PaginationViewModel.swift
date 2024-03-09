//
//  PaginationViewModel.swift
//  ReadLog
//
//  Created by 유석원 on 11/28/23.
//

import SwiftUI

class PaginationViewModel: ObservableObject {
    @Published var results: [BookInfo] = []
    
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
                
                let decodedData = try decoder.decode(JsonResponse.self, from: data)

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
//                    print(self?.results)
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
    
    func mappingToBookInfo(bookDataJsonResponse: BookDataJsonResponse, page: Int) -> BookInfo {
        // 사진 저장 안됨
        var bookInfo = BookInfo(id: bookDataJsonResponse.id,
                                author: bookDataJsonResponse.author,
                                bookDescription: bookDataJsonResponse.description,
                                image: nil,
                                isbn: bookDataJsonResponse.isbn,
                                link: bookDataJsonResponse.link,
                                readingStatus: false,
                                repeatTime: 0,
                                page: page,
                                pinned: false,
                                publisher: bookDataJsonResponse.publisher,
                                title: bookDataJsonResponse.title,
                                wish: false,
                                notes: [],
                                trackings: [],
                                readbooks: [])
        
        fetchImage(urlString: bookDataJsonResponse.coverImage) { imageData in
            if let imageData {
                bookInfo.image = UIImage(data: imageData)
            } else {
                print("Failed to fetch or convert image data.")
            }
        }
        print(bookInfo)
        return bookInfo
    }
    
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        let convertedUrl = urlString.replacingOccurrences(of: "coversum", with: "cover200")
        
        guard let url = URL(string: convertedUrl) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
        
        task.resume()
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
