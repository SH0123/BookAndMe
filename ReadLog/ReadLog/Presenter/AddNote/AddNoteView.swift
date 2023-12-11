//
//  AddNoteView.swift
//  ReadLog
//
//  Created by sanghyo on 11/13/23.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var showScannerSheet = false
    @State private var noteType: Note = .impressive
    @State private var contents: String = ""
    @State private var noteSelectionShow = false
    @Binding private var notes: [ReadLog]
    
    private let placeholder: String = "내용을 작성해보세요"
    private let dateFormatter: DateFormatter = Date.yyyyMdFormatter
    private var bookInfo: BookInfo
    
    init(_ bookInfo: BookInfo, _ note: Binding<[ReadLog]>) {
        self.bookInfo = bookInfo
        self._notes = note
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 40) {
                header
                ZStack(alignment: .topLeading) {
                    textField
                    labelButton(type: $noteType)
                        .padding(EdgeInsets(top: -20, leading: -20, bottom: 0, trailing: 0))
                }
            }
            .padding(.horizontal, 32)
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .toolbar(.hidden)
        .fullScreenCover(isPresented: $showScannerSheet, content: {
            scannerView
        })
    }
}

// Component
private extension AddNoteView {
    
    func labelButton(type: Binding<Note>) -> some View {
        Button(action: {
            noteSelectionShow = true
        }, label: {
            NoteLabel(type: type)
        }).confirmationDialog( "노트 타입", isPresented: $noteSelectionShow) {
            Button(Note.impressive.noteText) {
                noteType = .impressive
            }
            Button(Note.myThink.noteText) {
                    noteType = .myThink
                }
            }
            message: {Text("메모 타입을 선택해주세요")}
    }
    
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
            }
            Spacer()
            Button {
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
                    .bodyDefaultMultiLine(.black)
                    .padding(EdgeInsets(top: -5, leading: -7, bottom: 0, trailing: 0))
                    .scrollContentBackground(.hidden)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                addItem()
                                dismiss()
                            } label: {
                                Text("노트 저장")
                                    .foregroundStyle(Color.black)
                            }
                        }
                    }
                
                if contents.isEmpty {
                    Text(placeholder)
                        .bodyDefault(.darkGray)
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
        note.date = Date()
        
        if var log = bookInfo.readLog {
            log = log.adding(note) as NSSet
            bookInfo.readLog = log
        } else {
            bookInfo.readLog = [note]
        }
        
        do {
            try viewContext.save()
            notes.append(note)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
}

