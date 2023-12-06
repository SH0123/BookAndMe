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
    @FetchRequest (
        sortDescriptors: [],
        predicate: NSPredicate(format: "isbn == %@", "newBook1")
    ) private var books: FetchedResults<BookInfo>
    
    
    var body: some View {
        if let book = books.first {
            ZStack{
                HStack{
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
                }
                .frame(width: 323.0, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius:10)
                    .stroke(Color("gray"), lineWidth: 1)
                )
            }
        }else{
            Text("Book not found").title(Color.primary)
        }
    }
}

#Preview {
    displayBook().environment(\.managedObjectContext,
                   PersistenceController.preview.container.viewContext)
}
