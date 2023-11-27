//
//  displayBook.swift
//  ReadLog UI
//
//  Created by 이만 on 2023/11/03.
//

import SwiftUI

struct displayBook: View {
    var bookTitle: String = "보통의 언어들"
    var bookAuthor: String = "김이나"
    var bookPublisher: String = "위즈덤 하우스"
    var bookCover: String = "usualWords"
    
    var body: some View {
        ZStack{
            HStack{
                Image(bookCover)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 140)
                    .background(Color.white)
                VStack(alignment: .leading){
                    Text(bookTitle)
                        .title(Color.primary)
                        .padding(.bottom,10)
                    Text(bookAuthor)
                        .body2(Color.primary)
                        .padding(.bottom,2)
                    Text(bookPublisher)
                        .body2(Color.primary)
                        .padding(.bottom,2)
                }
                .padding(.leading,10)
                
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
        .frame(width: 300, height: 200) // Adjust the size as needed
        
        
    }
        
}

#Preview {
   
        displayBook()
}
