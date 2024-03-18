//
//  AladinManager.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import UIKit

struct AladinKeywordAPI: BookAPI {
    
    typealias DecodableType = AladinJsonResponse
    let baseUrlString = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=\(ApiKey.aladinKey)&SearchTarget=Book&output=js&Version=20131101"
    //&Query=\(keyword)&QueryType=Keyword&MaxResults=\(maxResult)&start=\(currentPage)
    let bookAPICaller = BookAPICaller<AladinJsonResponse>()
    let converter = AladinJsonConverter()
    
    
    func fetchBooks(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping ([BookInfo], Int) -> Void) {
        let urlString = baseUrlString + "&Query=\(keyword)&QueryType=Keyword&MaxResults=\(maxResult)&start=\(currentPage)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        bookAPICaller.fetchBooks(urlString: encodedUrlString) { aladinJsonResponse in
            let totalResults = aladinJsonResponse.totalResults
            let bookDataArray = converter.convertToBookInfo(from: aladinJsonResponse)
            completion(bookDataArray, totalResults)
        }
    }
}

struct AladinISBNAPI: BookAPI {
    
    typealias DecodableType = AladinJsonResponse
    let baseUrlString = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=\(ApiKey.aladinKey)&output=js&Version=20131101"
    //&itemIdType=ISBN13&ItemId=\(isbn)
    let bookAPICaller = BookAPICaller<AladinJsonResponse>()
    let converter = AladinJsonConverter()
    
    
    func fetchBooks(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping ([BookInfo], Int) -> Void) {
        let urlString = baseUrlString + "&itemIdType=ISBN13&ItemId=\(keyword)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }

        bookAPICaller.fetchBooks(urlString: encodedUrlString) { aladinJsonResponse in

            let totalResults = aladinJsonResponse.totalResults
            let bookDataArray = converter.convertToBookInfo(from: aladinJsonResponse)
            completion(bookDataArray, totalResults)
        }
    }
}


struct AladinJsonConverter {
    
    func convertToBookInfo(from decodedData: AladinJsonResponse) -> [BookInfo] {
        let filteredData = decodedData.item.filter { $0.isbn != "" }
        let bookDataArray: [BookInfo] = filteredData.map { bookDataJsonResponse in
            return mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse, page: bookDataJsonResponse.subInfo?.itemPage ?? 0)
//            if let itemPage = bookDataJsonResponse.subInfo?.itemPage {
//                return (mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse, page: itemPage))
//            } else {
//                return (mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse, page: 0))
//            }
        }
        print(bookDataArray)
        return bookDataArray
    }
    
    private func mappingToBookInfo(bookDataJsonResponse: AladinJsonResponseItem, page: Int) -> BookInfo {
        let bookInfo = BookInfo(id: String(bookDataJsonResponse.id),
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
    
    private func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
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

}
