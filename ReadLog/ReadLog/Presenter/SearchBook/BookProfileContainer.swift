//
//  BookProfileContainer.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct BookProfileContainer: View {
    var bookInfo: BookInfoData
    
    var body: some View {
        HStack {
            if bookInfo.coverImage == "" {
                if let data = bookInfo.dbImage, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .clipped()
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                }
            } else {
                URLImage(urlString: bookInfo.coverImage)
                    .padding(.vertical, 5)
            }
            
            VStack(alignment: .leading) {
                Text(bookInfo.title)
                    .body1(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 6)
                Text(bookInfo.author)
                    .body3(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 6)
                Text(bookInfo.publisher)
                    .body3(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 6)
                
                if bookInfo.dbNthCycle != 0 {
                    Text("지금까지 \(bookInfo.dbNthCycle)회독 했어요")
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
        .shadow(color: .primary, radius: 1, x: 2, y: 2)
//        .overlay(
//            RoundedRectangle(cornerRadius: 6)
//                .stroke(Color(.darkGray), lineWidth: 1)
//        )
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
    
    
}
