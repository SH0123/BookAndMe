//
//  BookProfileContainer.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI


struct BookProfileContainer: View {
//    @Binding var bookTitle: String
//    @Binding var bookAuthor: String
//    @Binding var bookPublisher: String
//    @Binding var bookNthCycle: Int
    
    @Binding var bookInfo: BookInfoData_Temporal
    
    // set bookNthCycle to 0 temporarily
    var bookNthCycle = 0
    
    
    
    var body: some View {
        let frameHeight: CGFloat = bookNthCycle != 0 ? 200.0 : 150.0
        
        HStack {
//            Image(systemName: "book")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100)
//                .clipped()
//                .padding(.horizontal, 15)
            URLImage(urlString: bookInfo.coverImage)
            
            VStack(alignment: .leading) {
//                Text(bookTitle)
//                    .padding(.vertical, 6)
//                Text(bookAuthor)
//                    .padding(.vertical, 6)
//                Text(bookPublisher)
//                    .padding(.vertical, 6)
                
                Text(bookInfo.title)
                    .padding(.vertical, 6)
                Text(bookInfo.author)
                    .padding(.vertical, 6)
                Text(bookInfo.publisher)
                    .padding(.vertical, 6)
                
                if bookNthCycle != 0 {
                    Text("지금까지 \(bookNthCycle)회독 했어요")
                        .padding(.vertical, 6)
                    
                }
            }
            .padding(.horizontal, 10)
            Spacer()
        }
        .frame(height: frameHeight)
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

//#Preview {
//    BookProfileContainer(
//        bookTitle: Binding.constant("책 제목"),
//        bookAuthor: Binding.constant("작가"),
//        bookPublisher: Binding.constant("출판사"),
//        bookNthCycle: Binding.constant(1)
//    )
//}
