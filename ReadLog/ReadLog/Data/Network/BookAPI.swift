//
//  BookAPI.swift
//  ReadLog
//
//  Created by sanghyo on 3/17/24.
//

import UIKit

protocol BookAPI {
    associatedtype DecodableType: Decodable
    
    var baseUrlString: String { get }
    var bookAPICaller: BookAPICaller<DecodableType> { get }
    
    func fetchBooks(keyword: String, maxResult: Int, currentPage: Int, _ completion: @escaping([BookInfo], Int)->Void)
}

