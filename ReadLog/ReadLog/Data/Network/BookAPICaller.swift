//
//  BookAPICaller.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import Foundation

struct BookAPICaller<BookType: Decodable> {
    
    func fetchBooks(urlString: String, _ completion: @escaping (BookType)->Void) {

        guard let url = URL(string: urlString) else {
            print("not possible with \(urlString)")
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
//                print(string)
            }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(BookType.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()

    }
}
