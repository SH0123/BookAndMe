//
//  AddNoteView.swift
//  ReadLog
//
//  Created by sanghyo on 11/13/23.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showScannerSheet = false
    @State private var noteType: Note = .impressive
    @State private var contents: String = ""
    
    private let placeholder: String = "내용을 작성해보세요"
    private let dateFormatter: DateFormatter = Date.yyyyMdFormatter
    private var bookInfo: BookInfo {
        BookInfo(context: self.viewContext)
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 40) {
                header
                ZStack(alignment: .topLeading) {
                    textField
                    NoteLabel(noteType)
                        .padding(EdgeInsets(top: -20, leading: -20, bottom: 0, trailing: 0))
                }
            }
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .toolbar(.hidden)
        .fullScreenCover(isPresented: $showScannerSheet, content: {
            scannerView
        })
    }
}

// Component
private extension AddNoteView {
    
    func labelButton(type: Note) -> some View {
        Button {
            // label 변경
        } label: {
            NoteLabel(type)
        }
    }
    
    var header: some View {
        HStack {
            Button {
                // back
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
            }
            Spacer()
            Button {
                // scan
                showScannerSheet = true
            } label: {
                Image(systemName: "doc.viewfinder")
                    .font(.system(size: 25))
            }
        }
        .tint(.black)
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
    }
    
    var textField: some View {
        VStack(alignment: .leading) {
            Text("\(dateFormatter.string(from: Date()))")
                .bodyDefault(.darkGray)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $contents)
                    .bodyDefault(.black)
                    .scrollContentBackground(.hidden)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                // save
                            } label: {
                                Text("노트 저장")
                                    .foregroundStyle(Color.black)
                            }
                        }
                    }
                
                if contents.isEmpty {
                    Text(placeholder)
                        .bodyDefault(.darkGray)
                        .padding(.vertical, 7.5)
                }
            }
        }
        .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.gray, lineWidth: 1)
        )
    }
    
    var scannerView: ScannerView {
        ScannerView { textPerPage in
            self.contents = textPerPage.joined(separator: "\n")
            self.showScannerSheet = false
        }
    }
}

// CoreData Connection
private extension AddNoteView {
    func addItem() {
        let note = ReadLog(context: viewContext)
        note.id = UUID()
        note.label = Int16(noteType.rawValue)
        note.book = bookInfo
        note.log = contents
        
        if var readLog = bookInfo.readLog {
            readLog = readLog.adding(note) as NSSet
            bookInfo.readLog = readLog
        } else {
            bookInfo.readLog = [note]
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
}


