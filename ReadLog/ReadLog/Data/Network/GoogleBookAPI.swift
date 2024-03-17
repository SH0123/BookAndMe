//
//  GoogleBookAPI.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import UIKit

struct GoogleBooksKeywordAPI: BookAPI {
    
    typealias DecodableType = GoogleBooksJsonResponse
    let baseUrlString = "https://www.googleapis.com/books/v1/volumes?"
    //q=\(keyword)&maxResults=\(maxResult)&startIndex=\(currentPage)
    let bookAPICaller = BookAPICaller<GoogleBooksJsonResponse>()
    let converter = GoogleConverter()
    
    
    func fetchBooks(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping ([BookInfo], Int) -> Void) {
        let urlString = baseUrlString + "q=\(keyword)&maxResults=\(maxResult)&startIndex=\(currentPage)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        bookAPICaller.fetchBooks(urlString: encodedUrlString) { googleJsonResponse in
            let totalResults = googleJsonResponse.totalItems
            let bookDataArray = converter.convertToBookInfo(from: googleJsonResponse)
            completion(bookDataArray, totalResults)
        }
    }
}

struct GoogleBooksISBNAPI: BookAPI {
    
    typealias DecodableType = GoogleBooksJsonResponse
    let baseUrlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:8960174890"
    //&itemIdType=ISBN13&ItemId=\(isbn)
    let bookAPICaller = BookAPICaller<GoogleBooksJsonResponse>()
    let converter = GoogleConverter()
    
    
    func fetchBooks(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping ([BookInfo], Int) -> Void) {
        let urlString = baseUrlString + "&itemIdType=ISBN13&ItemId=\(keyword)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        print("hello")
        bookAPICaller.fetchBooks(urlString: encodedUrlString) { googleJsonResponse in
            let totalResults = googleJsonResponse.totalItems
            let bookDataArray = converter.convertToBookInfo(from: googleJsonResponse)
            completion(bookDataArray, totalResults)
        }
    }
}

struct GoogleConverter {
    
    func convertToBookInfo(from decodedData: GoogleBooksJsonResponse) -> [BookInfo] {
        let filteredData = decodedData.items.filter { $0.volumeInfo.industryIdentifiers?.count != 0 && $0.volumeInfo.pageCount != 0 }
        let bookDataArray: [BookInfo] = filteredData.map { bookDataJsonResponse in
            return mappingToBookInfo(bookDataJsonResponse: bookDataJsonResponse)
        }
        return bookDataArray
    }
    
    private func mappingToBookInfo(bookDataJsonResponse: GoogleBooksJsonItem) -> BookInfo {
        var bookInfo = BookInfo(id: bookDataJsonResponse.id,
                                author: bookDataJsonResponse.volumeInfo.authors?.joined(separator: ", ") ?? "공식 작가 없음",
                                bookDescription: bookDataJsonResponse.volumeInfo.description ?? "공식 책 설명 없음",
                                coverImageUrl: bookDataJsonResponse.volumeInfo.imageLinks?.thumbnail ?? "",
                                image: nil,
                                isbn: bookDataJsonResponse.volumeInfo.industryIdentifiers?[0].identifier ?? "",
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
        
        fetchImage(urlString: bookDataJsonResponse.volumeInfo.imageLinks?.thumbnail ?? "") { imageData in
                if let imageData {
                    bookInfo.image = UIImage(data: imageData)
                } else {
                    bookInfo.image = UIImage(named: Literals.defaultImage)
                    print("Failed to fetch or convert image data.")
                }
        }
        
        return bookInfo
    }
    
    private func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
//        let convertedUrl = urlString.replacingOccurrences(of: "coversum", with: "cover200")
        
        guard let url = URL(string: urlString) else {
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
