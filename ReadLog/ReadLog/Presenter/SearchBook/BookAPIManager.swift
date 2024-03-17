//
//  BookAPIManager.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import Foundation

struct BookAPIManager {
    var keywordApi: any BookAPI {
        
        if let countryCode = Locale.current.region?.identifier {
            switch countryCode {
            case "KR":
                return AladinKeywordAPI()
            default:
                return GoogleBooksKeywordAPI()
            }
        } else {
            return GoogleBooksKeywordAPI()
        }
    }
    
    var isbnApi: any BookAPI {
        if let countryCode = Locale.current.region?.identifier  {
            switch countryCode {
            case "KR":
                return AladinISBNAPI()
            default:
                return GoogleBooksISBNAPI()
            }
        } else {
            return GoogleBooksISBNAPI()
        }
    }
}

extension BookAPIManager {
    func fetchBooks(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping ([BookInfo], Int)->Void) {
        keywordApi.fetchBooks(keyword: keyword, maxResult: maxResult, currentPage: currentPage) { bookInfoList, resultsCount in
            completion(bookInfoList, resultsCount)
        }
    }
    
    func fetchIsbnBooks(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping ([BookInfo], Int)->Void) {
        isbnApi.fetchBooks(keyword: keyword, maxResult: maxResult, currentPage: currentPage) { bookInfoList, resultsCount in
            completion(bookInfoList, resultsCount)
        }
    }
}
