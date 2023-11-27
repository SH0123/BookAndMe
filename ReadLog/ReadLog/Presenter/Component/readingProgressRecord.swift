//
//  readingProgressRecord.swift
//  ReadLog UI
//
//  Created by 이만 on 2023/11/04.
//

import SwiftUI

/*
 Button("Enter name") {
     showingAlert.toggle()
 }
 .alert("Enter your name", isPresented: $showingAlert) {
     TextField("Enter your name", text: $name)
     Button("OK", action: submit)
 } message: {
     Text("Xcode will print whatever you type.")
 }
}

func submit() {
 print("You entered \(name)")
}
 */

struct readingProgressRecord: View {
    @State private var showingPopup = false
    @State private var pageNumber: Int?
    
    var body: some View {
        ZStack{
            VStack{
                Button("어디까지 읽으셨나요?"){
                    showingPopup.toggle()
                }
                .padding()
                .title(Color.primary)
                .background(Color("lightBlue"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .alert("오늘의 독서", isPresented: $showingPopup) {
                    TextField("몇 페이지까지 읽으셨나요?", text: $pageNumber)
                    Button("Done", action: submit)
                }
            }
            func submit(){
                print("\(pageNumber)")
            }
            //.frame(width:600)
            
            //Overlay
            //only show the popup if showingPopup is true
            /*if showingPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        
                    }
                popupView(readingProgress: $pageNumber, isShowing: $showingPopup)
                
            }*/
            
        }
    }
    
/*struct popupView: View {
    @Binding var readingProgress: Int? //Binded to pageNumber
    @Binding var isShowing: Bool
    
    var body: some View {
        Button("")
        /*VStack {
            HStack{
                Spacer()
                Button(action:{
                    self.isShowing = false
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width:12, height: 12)
                        .foregroundStyle(.gray)
                        .padding(.top, 20)
                        .padding(.trailing,20)
                }
            }
            .frame(maxWidth: .infinity)
            
            Text("오늘의 독서").title(Color.primary)
            TextField("몇 페이지까지 읽으셨나요?", value: $readingProgress, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .body2(Color.primary)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Done"){
                //Perform actions when done is tapped
                self.isShowing = false
            }
            .padding()
            .title(Color.primary)
            
            Spacer()
        }
        .background(Color("lightBlue"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
        
    }*/
}
}*/


#Preview {
readingProgressRecord()
}
