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
    @State private var noteType: NoteType = .impressive
    @State private var contents: String = ""
    @State private var noteSelectionShow = false
    @Binding private var notes: [BookNoteEntity]
    @FocusState private var isInputActive: Bool
    
    private let placeholder: String = "내용을 작성해보세요"
    private let dateFormatter: DateFormatter = Date.yyyyMdFormatter
    private var bookInfo: BookInfoEntity
    
    init(_ bookInfo: BookInfoEntity, _ note: Binding<[BookNoteEntity]>) {
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
        .onTapGesture {
            isInputActive = false
        }
        .toolbar(.hidden)
        .fullScreenCover(isPresented: $showScannerSheet, content: {
            scannerView
        })
    }
}

// Component
private extension AddNoteView {
    
    func labelButton(type: Binding<NoteType>) -> some View {
        Button(action: {
            noteSelectionShow = true
        }, label: {
            NoteLabel(type: type)
        }).confirmationDialog( "노트 타입", isPresented: $noteSelectionShow) {
            Button(NoteType.impressive.noteText) {
                noteType = .impressive
            }
            Button(NoteType.myThink.noteText) {
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
            }
            Spacer()
            Button {
                showScannerSheet = true
            } label: {
                Image(systemName: "doc.viewfinder")
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
                    .focused($isInputActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                addItem() { note in
                                    notes.append(note)
                                }
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
    func addItem(_ completion: @escaping (BookNoteEntity)->()) {
        let note = BookNoteEntity(context: viewContext)
        note.id = UUID()
        note.label = Int16(noteType.rawValue)
        note.bookInfo = bookInfo
        note.content = contents
        note.date = Date()
        
        if var notes = bookInfo.bookNotes {
            notes = notes.adding(note) as NSSet
            bookInfo.bookNotes = notes
        } else {
            bookInfo.bookNotes = [note]
        }
        
        do {
            try viewContext.save()
            completion(note)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
}

