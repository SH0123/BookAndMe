//
//  BookApiHandler.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import Foundation

class BookApiHandler<API: BookDecodableAPI> {
    private let api: API
    
    init(api: API, keyword: String, maxResult: Int, currentPage: Int) {
        self.api = api
    }
    
    func fetchAndDecode(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping([BookInfo])->Void) {
        let urlString = api.getUrlString(keyword: keyword, maxResult: maxResult, currentPage: currentPage)
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
                let decodedData = try self.api.decode(data: data)
                DispatchQueue.main.async {
                    let bookDataArray = self.api.convertToBookInfo(from: decodedData)
                    completion(bookDataArray)
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
        
        
    }
}
