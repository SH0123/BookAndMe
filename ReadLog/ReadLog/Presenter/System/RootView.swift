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
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ReadingBookView(tab: $selectedTab)
                .tabItem {
                    Label("읽고있어요", systemImage: "book")
                }
                .tag(0)
            BookWishlistView(tab: $selectedTab)
                .tabItem {
                    Label("찜했어요", systemImage: "heart")
                }
                .tag(1)
            BookShelfView()
                .tabItem {
                    Label("다읽었어요", systemImage: "books.vertical")
                }
                .tag(2)
            SettingView()
                .tabItem {
                    Label("설정", systemImage: "gearshape")
                }
                .tag(3)
        }
        
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

