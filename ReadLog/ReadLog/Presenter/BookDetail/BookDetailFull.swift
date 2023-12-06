//
//  BookDetailFull.swift
//  ReadLog
//
//  Created by 이만 on 2023/11/21.
//

import SwiftUI

struct BookDetailFull: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    displayBook().environment(\.managedObjectContext,
                                               PersistenceController.preview.container.viewContext)
                    ReadingTrackerView()
                }
            }
            .padding()
            .background(Color("backgroundColor"))
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action:{
                        self.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.primary)
                    }
                }
                
                //TODO: When the button is pressed, add book into readList
                ToolbarItem(placement: .topBarTrailing){
                    Button("완독"){
                }
                    .body1(Color.primary)
                }
            }
        }
    }
}

#Preview {
    BookDetailFull()
}
