//
//  BookInfoView.swift
//  ReadLog
//
//  Created by 김현수 on 2023/12/06.
//

import SwiftUI
import CoreData

struct BooksView : View {
    @Environment(\.managedObjectContext) private var viewContext
    var items: FetchedResults<ReadingList>
    
    let pageWidth: CGFloat = 265 // 한 페이지 너비
    let spacing: CGFloat = 28 // 뷰 사이의 공간 크기
    @Binding var currentIndex: Int // 현재 가리키는 page넘버
    @State var relativeOffset: CGFloat = 0// 손가락으로 page를 넘기는 정도
    
    var body: some View {
        GeometryReader { proxy in
            let baseOffset: CGFloat = (proxy.size.width - pageWidth) / 2
            let offset: CGFloat = baseOffset + relativeOffset
            
            HStack(spacing: spacing) {
                ForEach(items, id: \.self) { item in
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(
                                width: pageWidth,
                                height: proxy.size.height)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 5)
                        Button(action: {
                            item.pinned.toggle()
                            do {
                                try viewContext.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }){
                            Image(systemName: "pin")
                        }
                        .offset(x: 105, y: -135)
                        .foregroundColor(item.pinned == true ? .red : .black)
                        VStack{
                            Text(item.book!.isbn!)
                        }
                        .frame(alignment: .center)
                    }
                }
                NavigationLink(destination: BookSearchView().navigationBarBackButtonHidden(true)) {
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
                }
                
            }
            .offset(x: offset)
            .highPriorityGesture(
                DragGesture()
                    .onChanged { value in
                        relativeOffset = -CGFloat(currentIndex) * (pageWidth + spacing) + value.translation.width
                    }
                    .onEnded { value in
                        let increment = Int((-value.translation.width/pageWidth).rounded())
                        withAnimation(Animation.easeInOut(duration: 0.3)){
                            currentIndex = max(min(currentIndex + increment, items.count), 0)
                            relativeOffset = -CGFloat(currentIndex) * (pageWidth + spacing)
                        }
                        
                    }
            )
        }
        .frame(height: 328)
        .padding(.vertical, 15)
    }
}

