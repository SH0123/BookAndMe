//
//  BookDecodableAPI.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import Foundation

protocol BookDecodableAPI {
    associatedtype DecodableType: Codable
    
    func getUrlString(keyword: String, maxResult: Int, currentPage: Int) -> String
    func getISBNUrlString(isbn: String, maxResult: Int, currentPage: Int) -> String
    func decode(data: Data) throws -> DecodableType
    func convertToBookInfo(from decodedData: DecodableType) -> [BookInfo]
}

struct AladinAPI: BookDecodableAPI {
    typealias DecodableType = AladinJsonResponse
    
    private let keyword: String
    private let currentPage: Int
    private let maxResult: Int
    
    
    init(keyword: String, currentPage: Int, maxResult: Int) {
        self.keyword = keyword
        self.currentPage = currentPage
        self.maxResult = maxResult
    }
    
    func decode(data: Data) throws -> DecodableType {
        let decoder = JSONDecoder()
        return try decoder.decode(DecodableType.self, from: data)
    }
    
    func getUrlString(keyword: String, maxResult: Int, currentPage: Int) -> String {
        return "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=\(ApiKey.aladinKey)&Query=\(keyword)&QueryType=Keyword&MaxResults=\(maxResult)&start=\(currentPage)&SearchTarget=Book&output=js&Version=20131101"
    }
    
    func getISBNUrlString(isbn: String, maxResult: Int, currentPage: Int) -> String {
        return "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=\(ApiKey.aladinKey)&itemIdType=ISBN13&ItemId=\(isbn)&output=js&Version=20131101"
    }
    
    func convertToBookInfo(from decodedData: DecodableType) -> [BookInfo] {
        let filteredData = decodedData.item.filter { $0.isbn != "" }
        let bookDataArray: [BookInfo] = filteredData.map { bookDataJsonResponse in
            if let itemPage = bookDataJsonResponse.subInfo?.itemPage {
                return (mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse, page: itemPage))
            } else {
                return (mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse, page: 0))
            }
        }
        
        return bookDataArray
    }
    
    private func mappingToBookInfo(bookDataJsonResponse: AladinJsonResponseItem, page: Int) -> BookInfo {
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
        
        // fetch image 상황에 따라 필요
        
        return bookInfo
    }
}

struct GoogleBooksAPI: BookDecodableAPI {
    typealias DecodableType = GoogleBooksJsonResponse
    
    private let keyword: String
    private let currentPage: Int
    private let maxResult: Int
    
    init(keyword: String, currentPage: Int, maxResult: Int) {
        self.keyword = keyword
        self.currentPage = currentPage
        self.maxResult = maxResult
    }
    
    func decode(data: Data) throws -> DecodableType {
        let decoder = JSONDecoder()
        return try decoder.decode(DecodableType.self, from: data)
    }
    
    func getUrlString(keyword: String, maxResult: Int, currentPage: Int) -> String {
        return "https://www.googleapis.com/books/v1/volumes?q=\(keyword)&maxResults=\(maxResult)&startIndex=\(currentPage)"
    }
    
    func getISBNUrlString(isbn: String, maxResult: Int, currentPage: Int) -> String {
        return "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)"
    }
    
    func convertToBookInfo(from decodedData: DecodableType) -> [BookInfo] {
        let filteredData = decodedData.items.filter { $0.volumeInfo.industryIdentifiers.count != 0 && $0.volumeInfo.pageCount != 0 }
        let bookDataArray: [BookInfo] = filteredData.map { bookDataJsonResponse in
            return mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse)
        }
        return bookDataArray
    }
    
    private func mappingToBookInfo(bookDataJsonResponse: GoogleBooksJsonItem) -> BookInfo {
        var bookInfo = BookInfo(id: bookDataJsonResponse.id,
                                author: bookDataJsonResponse.volumeInfo.authors.joined(separator: ", "),
                                bookDescription: bookDataJsonResponse.volumeInfo.description ?? "공식 책 설명 없음",
                                coverImageUrl: bookDataJsonResponse.volumeInfo.imageLinks.thumbnail,
                                image: nil,
                                isbn: bookDataJsonResponse.volumeInfo.industryIdentifiers[0].identifier,
                                link: bookDataJsonResponse.volumeInfo.infoLink ?? "",
                                readingStatus: false,
                                repeatTime: 0,
                                page: bookDataJsonResponse.volumeInfo.pageCount ?? 0,
                                publisher: bookDataJsonResponse.volumeInfo.publisher ?? "출판사 없음",
                                title: bookDataJsonResponse.volumeInfo.title,
                                wish: false,
                                notes: [],
                                trackings: [],
                                readbooks: [])
        return bookInfo
    }
}

