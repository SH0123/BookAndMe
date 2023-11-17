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
    
    var body: some View {
        VStack{
            ZStack{
                Text("읽고 있는 책 목록")
                    .font(Font.custom("omyu pretty", size: 27))
                    .foregroundColor(.black)
                    .frame(alignment: .center)
                HStack{
                    Spacer()
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 60, height: 36)
                        .background(
                            Image("path-to-image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipped()
                        )
                }
            }
            Text("0권 / 0권")
                .font(Font.custom("omyu pretty", size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .frame(width: 231, height: 21, alignment: .top)
            VStack{
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.isbn!)")
                    } label: {
                        Text(item.isbn!)
                    }
                }
            }
            
            Spacer()
                .frame(height: 50)
            
            HStack{
                Text("최근 기록")
                    .font(Font.custom("omyu pretty", size: 22))
                    .foregroundColor(.black)
                    .frame(width: 300, height: 21, alignment: .topLeading)
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
                    .frame(width: 333, height: 110, alignment: .top)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 332.00287, height: 1)
                    .background(Color(red: 0.76, green: 0.76, blue: 0.76))
            }
            .frame(height: 200)
        }
        .frame(width: 390, height: 844)
        .background(Color(red: 0.98, green: 0.97, blue: 0.95))
    }
    
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
