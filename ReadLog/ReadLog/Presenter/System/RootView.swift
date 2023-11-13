//
//  ContentView.swift
//  ReadLog
//
//  Created by sanghyo on 2023/11/01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            
        VStack {
            displayBook()
            viewBookMemo(memos: Memo.sampleData)
            readingProgressRecord()
        }
        .padding()
    }
    .background(Color("background"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
