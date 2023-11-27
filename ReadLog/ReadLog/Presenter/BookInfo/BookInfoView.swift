//
//  BookInfoView.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct BookInfoView: View {
    @Binding var bookInfo: BookInfoData_Temporal
    
    @State var like = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    BookProfileContainer(bookInfo: $bookInfo)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        Text("책 소개")
                        Spacer()
                        Button {
                            print("move to book purchase link")
                            openURL(URL(string: bookInfo.link)!)
                        } label: {
                            Image(systemName: "link")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    Text(bookInfo.description)
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
                .padding(.top, 7)
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
            }
            .navigationTitle("책 정보")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
