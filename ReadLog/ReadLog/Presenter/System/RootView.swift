//
//  ContentView.swift
//  ReadLog
//
//  Created by sanghyo on 2023/11/01.
//

import SwiftUI
import CoreData



struct ContentView: View {
    var body: some View {
        TabView {
            ReadingBookView()
                .tabItem {
                    Label("읽고있어요", systemImage: "book")
                }
            //TODO: 두번째 탭 찜 목록으로 바꾸기
            BookSearchView()
                .tabItem {
                    Label("찜했어요", systemImage: "heart")
                }
            BookShelfView()
                .tabItem {
                    Label("다읽었어요", systemImage: "books.vertical")
                }
        }
    }
}

#Preview {
    ContentView()
}
