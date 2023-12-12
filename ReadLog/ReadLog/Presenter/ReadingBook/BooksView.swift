//
//  BooksView.swift
//  ReadLog
//
//  Created by 김현수 on 2023/12/06.
//

import SwiftUI
import CoreData

struct BooksView : View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var tab: Int
    var items: FetchedResults<ReadingList>
    
    let pageWidth: CGFloat = 245 // 한 페이지 너비 265
    let spacing: CGFloat = 28 // 뷰 사이의 공간 크기
    @Binding var currentIndex: Int // 현재 가리키는 page넘버
    @State var relativeOffset: CGFloat = 0// 손가락으로 page를 넘기는 정도
    
    var body: some View {
        GeometryReader { proxy in
            let baseOffset: CGFloat = (proxy.size.width - pageWidth) / 2
            let offset: CGFloat = baseOffset + relativeOffset
            
            LazyHStack(spacing: spacing) {
                ForEach(items, id: \.self) { item in
                    NavigationLink(destination: BookDetailFull(item.book, isRead: false).navigationBarBackButtonHidden(true)) {
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(
                                    width: pageWidth,
                                    height: proxy.size.height)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 5)
                            if let book = item.book {
                                if let imageData = book.image, let uiImage =
                                    UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(15)
                                        .shadow(radius: 4, y: 4)
                                }
                                else {
                                    if let title = book.title {
                                        VStack {
                                            Text(title)
                                            Text("이미지를 로딩중입니다")
                                                .foregroundStyle(Color.skyBlue)
                                        }
                                    }
                                    else {
                                        Spacer()
                                    }
                                }
                            }
                            Button(action: {
                                item.pinned.toggle()
                                do {
                                    try viewContext.save()
                                } catch {
                                    let nsError = error as NSError
                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                            }){
                                ZStack{
                                    Circle()
                                        .foregroundColor(item.pinned == true ? .yellow : .clear)
                                    Image("pin")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                
                            }
                            .frame(width: 25, height: 25)
                            .offset(x: 105, y: -135)
                        }
                    }
                    .frame(width: pageWidth)
                }
                Button(action: {tab = 1}, label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(
                                width: pageWidth,
                                height: proxy.size.height)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 5)
                        Image("simple-line-icons:plus")
                            .frame(width: 70, height: 70)
                    }
                })
                
            }
            .offset(x: offset)
            .highPriorityGesture(
                DragGesture()
                    .onChanged { value in
                        relativeOffset = -CGFloat(currentIndex) * (pageWidth + spacing) + value.translation.width
                    }
                    .onEnded { value in
                        let increment = Int((-value.translation.width/pageWidth).rounded())
                        currentIndex = max(min(currentIndex + increment, items.count), 0)
                        withAnimation(Animation.easeInOut(duration: 0.3)){
                            relativeOffset = -CGFloat(currentIndex) * (pageWidth + spacing)
                        }
                        
                    }
            )
        }
        .frame(maxHeight: 310)
        .padding(.vertical, 15)
    }
}

