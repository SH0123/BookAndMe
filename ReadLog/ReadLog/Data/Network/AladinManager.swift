//
//  AladinManager.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import Foundation

struct AladinManager {
    
    // TODO: isbn 검색용 url 적용 -> 이미지 저장 필요 x
    
    func fetchAndDecode(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping([BookInfo], Int)->Void) {
        let urlString = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=\(ApiKey.aladinKey)&Query=\(keyword)&QueryType=Keyword&MaxResults=\(maxResult)&start=\(currentPage)&SearchTarget=Book&output=js&Version=20131101"
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
                let decodedData = try decoder.decode(AladinJsonResponse.self, from: data)
                DispatchQueue.main.async {
                    let bookDataArray = convertToBookInfo(from: decodedData)
                    completion(bookDataArray, decodedData.totalResults)
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func convertToBookInfo(from decodedData: AladinJsonResponse) -> [BookInfo] {
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
        
        // TODO: fetch image 처음 독서 시작하는 경우에만 필요, isbn으로 검색하는 경우는 필요 x
        
        return bookInfo
    }

}
