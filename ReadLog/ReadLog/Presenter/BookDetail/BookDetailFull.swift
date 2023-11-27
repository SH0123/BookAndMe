//
//  BookDetailFull.swift
//  ReadLog
//
//  Created by 이만 on 2023/11/21.
//

import SwiftUI

struct BookDetailFull: View {
    var body: some View {
        NavigationStack{
            ZStack{
                
                VStack {
                    displayBook()
                    ReadingTrackerView()
                    
                }
                .padding()
            }
            .background(Color("backgroundColor"))
        }
    }
}

#Preview {
    BookDetailFull()
}
