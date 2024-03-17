//
//  GoogleBooksManager.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import Foundation

struct GoogleBooksManager {
    
    func fetchAndDecode(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping([BookInfo])->Void) {
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(keyword)&maxResults=\(maxResult)&startIndex=\(currentPage)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        guard let url = URL(string: encodedUrlString) else {
            print("not possible with \(encodedUrlString)")
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
            if let string = String(data: data, encoding: .utf8) {
                print(string)
            }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(GoogleBooksJsonResponse.self, from: data)
                DispatchQueue.main.async {
                    let bookDataArray = convertToBookInfo(from: decodedData)
                    completion(bookDataArray)
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func convertToBookInfo(from decodedData: GoogleBooksJsonResponse) -> [BookInfo] {
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
