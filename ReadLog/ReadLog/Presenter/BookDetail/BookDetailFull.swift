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
                
                ToolbarItem(placement: .topBarTrailing){
                    //Button() complete reading
                }
            }
        }
    }
}

#Preview {
    BookDetailFull()
}
