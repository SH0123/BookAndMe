//
//  readingProgressRecord.swift
//  ReadLog UI
//
//  Created by 이만 on 2023/11/04.
//

import SwiftUI

struct readingProgressRecord: View {
    @State private var showingPopup = false
    @State private var pageNumber: Int?
    
    var body: some View {
        
        VStack{
            Button("어디까지 읽으셨나요?"){
                self.showingPopup = true
            }
            .fontWeight(.semibold)
            .foregroundStyle(Color.black)
            .padding()
            //.frame(maxWidth: .infinity)
            .background(Color("lightBlue"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        //.frame(maxWidth: toSet, maxHeight: .infinity)
        
        //Overlay
        .overlay(
            //only show the popup if showingPopup is true
            Group{
                if showingPopup {
                    popupView(readingProgress: $pageNumber, isShowing: $showingPopup)
                    
                }
            }
        )
        
    }
    
    struct popupView: View {
        @Binding var readingProgress: Int? //Binded to pageNumber
        @Binding var isShowing: Bool
        
        var body: some View {
            VStack {
                HStack{
                    Spacer()
                    Button(action:{
                        self.isShowing = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width:24, height: 24)
                            .foregroundStyle(.gray)
                            .padding(.top, 20)
                            .padding(.trailing,20)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text("오늘의 독서").title(Color.primary)
                TextField("몇 페이지까지 읽으셨나요?", value: $readingProgress, formatter: NumberFormatter())
                    .mini(Color("gray"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Done"){
                    //Perform actions when done is tapped
                    self.isShowing = false
                }
                .padding()
                
                Spacer()
            }
            .frame(width:300, height:200)
            .background(Color("lightBlue"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            //.shadow(radius: 5)
            .padding()
            // .background(Color.black.opacity(0.4)ignoresSafeArea().onTapGesture)
            
        }
    }
}


#Preview {
    readingProgressRecord()
}
