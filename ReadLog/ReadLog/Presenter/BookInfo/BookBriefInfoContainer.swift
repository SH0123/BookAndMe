//
//  BookBriefInfoContainer.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct BookBriefInfoContainer: View {
    @Binding var bookTitle: String
    @Binding var bookAuthor: String
    @Binding var bookPublisher: String
    @Binding var bookNthCycle: Int
    
    var body: some View {
        HStack {
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .clipped()
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading) {
                Text(bookTitle)
                    .padding(.vertical, 6)
                Text(bookAuthor)
                    .padding(.vertical, 6)
                Text(bookPublisher)
                    .padding(.vertical, 6)
                Text("지금까지 \(bookNthCycle)회독 했어요")
                    .padding(.vertical, 6)
            }
            Spacer()
        }
        .frame(height: 200)
        .background(Color.primary.colorInvert())
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .primary, radius: 1, x: 2, y: 2)
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}

#Preview {
    BookBriefInfoContainer(
        bookTitle: Binding.constant("책 제목"),
        bookAuthor: Binding.constant("작가"),
        bookPublisher: Binding.constant("출판사"),
        bookNthCycle: Binding.constant(0)
    )
}
