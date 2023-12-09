//
//  BookProfileContainer.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI


struct BookProfileContainer: View {
//    @Binding var bookInfo: BookInfoData_Temporal
    var bookInfo: BookInfoData
    
    // set bookNthCycle to 0 temporarily
    var bookNthCycle = 0
    
    
    
    var body: some View {
//        let frameHeight: CGFloat = bookNthCycle != 0 ? 200.0 : 150.0
        
        HStack {
            URLImage(urlString: bookInfo.coverImage)
                .padding(.vertical, 5)
            
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
                
                if bookNthCycle != 0 {
                    Text("지금까지 \(bookNthCycle)회독 했어요")
                        .body2(.darkBrown)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 6)
                    
                }
                
                // show page number if possible
                
                if bookInfo.itemPage != 0 {
                    Text("쪽 수: \(bookInfo.itemPage)")
                        .body3(.black)
                        .padding(.vertical, 6)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            Spacer()
        }
//        .frame(height: frameHeight)
        .background(Color.primary.colorInvert())
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(.darkGray), lineWidth: 1)
        )
//        .clipShape(RoundedRectangle(cornerRadius: 6))
//        .shadow(color: .primary, radius: 1, x: 2, y: 2)
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
    
    
}
