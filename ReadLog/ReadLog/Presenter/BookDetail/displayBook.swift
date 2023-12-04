//
//  displayBook.swift
//  ReadLog UI
//
//  Created by 이만 on 2023/11/03.
//

import SwiftUI
import UIKit
import CoreData

struct displayBook: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    //var bookISBN: String
    
    //Fetch book info
    @FetchRequest (
        sortDescriptors: [],
        predicate: NSPredicate(format: "isbn == %@", "newBook1")
    ) private var books: FetchedResults<BookInfo>
    
    
    /*var bookTitle: String = "보통의 언어들"
    var bookAuthor: String = "김이나"
    var bookPublisher: String = "위즈덤 하우스"
    var bookCover: String = "bookExample"*/
    
    var body: some View {
        if let book = books.first {
            ZStack{
                HStack{
                    //NavigationLink(destination:BookInfoView(bookInfo: book)){
                    if let imageData = book.image, let uiImage = UIImage(data:imageData){
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 140)
                            .background(Color.white)
                    }else{
                        Image(systemName: "book")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 140)
                            .background(Color.white)
                    }
                    VStack(alignment: .leading){
                        Text(book.title ?? "Unknown Title")
                            .title(Color.primary)
                            .padding(.bottom,10)
                        Text(book.author ?? "Unknown Author")
                            .body2(Color.primary)
                            .padding(.bottom,2)
                        Text(book.publisher ?? "Unknown Publisher")
                            .body2(Color.primary)
                            .padding(.bottom,2)
                    }
                    .padding(.leading,10)
                    
                    // } book tu kena CoreData kot
                }
                .padding()
                
                .frame(width: 323.0, height: 200)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius:8, x: 0, y: 4)
                .overlay(RoundedRectangle(cornerRadius:10)
                    .stroke(Color("gray"), lineWidth: 1)
                         
                         
                )
                
            }
            .frame(width: 300, height: 200)
        }else{
            Text("Book not found").title(Color.primary)
        }
        
        
    }
        
}

#Preview {
    displayBook().environment(\.managedObjectContext,
                   PersistenceController.preview.container.viewContext)
}
