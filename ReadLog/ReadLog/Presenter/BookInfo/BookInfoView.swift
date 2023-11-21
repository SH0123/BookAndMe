//
//  BookInfoView.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct BookInfoView: View {
    // later change into binding variables (take data from BookSearchView's selection)
    @State var bookTitle: String = "책 제목"
    @State var bookAuthor: String = "작가"
    @State var bookPublisher: String = "출판사"
    @State var bookNthCycle: Int = 1
    @State var bookIntroduce: String = 
        """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec dapibus augue. Aliquam ut fermentum metus, ut volutpat sapien. Nunc cursus felis convallis nulla ornare, a gravida diam efficitur. Mauris odio eros, egestas vitae mollis eu, mattis vel diam. Donec nec porttitor nisl. Fusce risus diam, consequat eget magna congue, pretium cursus sem. Fusce sollicitudin pretium erat sodales vulputate. Vivamus sed viverra magna. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi ligula nulla, elementum luctus volutpat id, convallis vitae nunc.
        """
    
    @State var like = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    BookProfileContainer(bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookPublisher: $bookPublisher, bookNthCycle: $bookNthCycle)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        Text("책 소개")
                        Spacer()
                        Button {
                            print("move to book purchase link")
                        } label: {
                            Image(systemName: "link")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    Text(bookIntroduce)
                        .padding(.vertical, 15)
                        .padding(.horizontal)
                        .lineSpacing(20)
                }
                
                Spacer()
                
                Divider()
                HStack {
                    Button {
                        print("add/delete from wishlist")
                        like.toggle()
                    } label: {
                        Image(systemName: like ? "heart.fill" : "heart")
                            .foregroundColor(.customPink)
                            .font(.system(size: 35))
                    }
                    
                    Button {
                        print("start to read the book.")
                    } label: {
                        Text("독서 시작")
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 10)
                    .foregroundColor(.black)
                    .background(Color.lightBlue)
                    .cornerRadius(5.0)
                }
                .padding(.top, 5)
                .padding(.horizontal, 15)
            }
            .navigationTitle("책 정보")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BookInfoView()
}
