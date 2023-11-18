//
//  ContentView.swift
//  ReadLog
//
//  Created by sanghyo on 2023/11/01.
//

import SwiftUI

class PopUpHelper: ObservableObject {
    @Published var showPopUp: Bool = false
}

struct ContentView: View {
    
    @StateObject var popUpControl: PopUpHelper = PopUpHelper()
    
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
