//
//  ContentView.swift
//  ReadLog
//
//  Created by sanghyo on 2023/11/01.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BookInfo.isbn, ascending: true)],
        animation: .default)
    private var items: FetchedResults<BookInfo>
    @State private var isMenuExpanded = false
    
    var body: some View {
        VStack{
            ZStack{
                Text("읽고 있는 책 목록")
                    .font(Font.custom("omyu pretty", size: 27))
                    .foregroundColor(.black)
                    .frame(alignment: .center)
                HStack{
                    Spacer()
                    Menu{
                        Button("설정", action: {})
                    } label: {
                        Image("path-to-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 36, height: 36)
                            .clipped()
                    }
                        .foregroundColor(.clear)
                        .frame(width: 60, height: 36)
                        .padding(.trailing, 10)
                }
            }
            Text("0권 / \(items.count)권")
                .font(Font.custom("omyu pretty", size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .frame(width: 231, height: 21, alignment: .top)
            ScrollView(.horizontal) {
                HStack {
                    Spacer(minLength: 70)
                    ForEach(items) { item in
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 258, height: 328)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 5)
                            .padding(.trailing, 30)
                    }
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 258, height: 328)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 5)
                        Image("simple-line-icons:plus")
                            .frame(width: 70, height: 70)
                    }
                    Spacer(minLength: 70)
                }
                .padding(.bottom, 15)
            }
            
            Spacer()
                .frame(height: 30)
            
            HStack{
                Text("최근 기록")
                    .font(Font.custom("omyu pretty", size: 22))
                    .foregroundColor(.black)
                    .frame(width: 330, height: 21, alignment: .leading)
                    .padding(3)
            }
            VStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 332.00287, height: 1)
                    .background(Color(red: 0.76, green: 0.76, blue: 0.76))
                Spacer()
                Text("책에 대한 기록이 아직 없어요.\n\n탭 해서 기록을 추가해 보세요")
                    .font(Font.custom("omyu pretty", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
                Spacer()
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 332.00287, height: 1)
                    .background(Color(red: 0.76, green: 0.76, blue: 0.76))
            }
            .frame(height: 150)
        }
        .frame(width: 390, height: 844)
        .background(Color(red: 0.98, green: 0.97, blue: 0.95))
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
