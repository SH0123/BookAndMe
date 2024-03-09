//
//  BookProfileContainer.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct BookProfileContainer: View {
    var bookInfo: BookInfo
    
    var body: some View {
        HStack {
            if bookInfo.image == nil {
                Image("noImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .clipped()
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
            } else {
                Image(uiImage: bookInfo.image ?? UIImage(named: "noImage")!)
                    .padding(.vertical, 5)
            }
            
            VStack(alignment: .leading) {
                Text(bookInfo.title)
                    .body2(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 6)
                Text(bookInfo.author)
                    .mini(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 6)
                Text(bookInfo.publisher)
                    .mini(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 6)
                
                if bookInfo.repeatTime != 0 {
                    Text("지금까지 \(bookInfo.repeatTime)회독 했어요")
                        .body2(.darkBrown)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 6)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            Spacer()
        }
        .background(Color.primary.colorInvert())
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(radius: 4, x: 2, y: 2)
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
    
    
}
