//
//  BookShelfCell.swift
//  ReadLog
//
//  Created by sanghyo on 11/27/23.
//

import SwiftUI
import UIKit

struct BookShelfCell: View {
    var renderedBook: [BookInfo?]
    
    var body: some View {
        VStack(spacing: 5) {
            bookRow(renderedBook).padding(.horizontal, 10)
            horizontalLine
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.backgroundColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 5)
    }
}

private extension BookShelfCell {
    @ViewBuilder
    func bookRow(_ bookList: [BookInfo?]) -> some View {
        HStack(alignment: .center) {
            bookCell(bookList[0])
                .padding(.horizontal, 20)
            bookCell(bookList[1])
                .padding(.horizontal, 20)
            bookCell(bookList[2])
                .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    func bookCell(_ book: BookInfo?) -> some View {
        if let book = book {
            NavigationLink(destination: BookDetailFull(book, isRead: true).navigationBarBackButtonHidden(true)){
                if let imageData = book.image, let uiImage =
                    UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .shadow(radius: 4, y: 4)
                }
            }
        }
        else {
            Spacer()
                .frame(width: 80)
        }
    }
    
    var horizontalLine: some View {
        Rectangle()
            .foregroundStyle(Color.white)
            .frame(width: 380, height: 6)
            .shadow(radius: 4, y: 4)
    }
    
}

struct BookExample: Identifiable {
    let id: Int
    let imageName: String
    
    static var mock: [BookExample?] {
        return [
            BookExample(id: 0, imageName: "bookExample"),
            BookExample(id: 1, imageName: "bookExample"),
            BookExample(id: 3, imageName: "bookExample"),
            BookExample(id: 4, imageName: "bookExample"),
            nil,
            
        ]
    }
}

