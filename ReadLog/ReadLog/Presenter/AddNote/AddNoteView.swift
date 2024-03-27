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
    @State private var noteDate: Date = Date()
    @Binding private var notes: [BookNote]
    @FocusState private var isInputActive: Bool
    
    private let addBookNoteUseCase: AddBookNoteUseCase
    private let fetchBookNoteUseCase: FetchBookNoteUseCase
    private let updateBookNoteUseCase: UpdateBookNoteUseCase
    private let placeholder: String = "내용을 작성해보세요"
    private let dateFormatter: DateFormatter = Date.yyyyMdFormatter
    private var bookInfo: BookInfo
    private let bookNote: BookNote?
    
    init( _ bookInfo: BookInfo, _ notes: Binding<[BookNote]>, _ bookNote: BookNote?, _ addBookNoteUseCase: AddBookNoteUseCase = AddBookNoteUseCaseImpl(), 
          _ fetchBookNoteUseCase: FetchBookNoteUseCase = FetchBookNoteUseCaseImpl(),
          _ updateBookNoteUseCase: UpdateBookNoteUseCase = UpdateBookNoteUseCaseImpl()) {
        self.addBookNoteUseCase = addBookNoteUseCase
        self.fetchBookNoteUseCase = fetchBookNoteUseCase
        self.updateBookNoteUseCase = updateBookNoteUseCase
        self.bookInfo = bookInfo
        self._notes = notes
        self.bookNote = bookNote
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
                        .padding(EdgeInsets(top: -20, leading: -15, bottom: 0, trailing: 0))
                }
            }
            .padding(.horizontal, 20)
        }
        .onTapGesture {
            isInputActive = false
        }
        .toolbar(.hidden)
        .fullScreenCover(isPresented: $showScannerSheet, content: {
            scannerView
        })
        .onAppear {
            if let bookNote, let noteId = bookNote.id, let date = bookNote.date, let content = bookNote.content {
                fetchBookNoteUseCase.execute(with: noteId, of: nil) { _ in
                    noteDate = date
                    contents = content
                }
            }
        }
    }
}

// Component
private extension AddNoteView {
    
    func labelButton(type: Binding<NoteType>) -> some View {
        Button(action: {
            noteSelectionShow = true
        }, label: {
            NoteLabel(type: type)
        })
        .confirmationDialog( "노트 타입", isPresented: $noteSelectionShow) {
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
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10)
            }
            Spacer()
            Button {
                showScannerSheet = true
            } label: {
                Image(systemName: "doc.viewfinder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 23)
            }
        }
        .tint(.black)
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
    }
    
    var textField: some View {
        VStack(alignment: .leading) {
            Text("\(dateFormatter.string(from: noteDate))")
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
                                saveNote() { note in
                                    // TODO: 수정 혹은 저장
                                    if let index = notes.firstIndex(where: {$0.id == note.id}) {
                                        notes[index] = note
                                    } else {
                                        notes.append(note)
                                    }
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

// Function
private extension AddNoteView {
    func saveNote(_ completion: @escaping (BookNote)->()) {
        if let bookNote, let noteId = bookNote.id {
            editItem(noteId: noteId) { note in
                completion(note)
            }
        } else {
            addItem { note in
                completion(note)
            }
        }
    }
}

// CoreData Connection
private extension AddNoteView {
    func addItem(_ completion: @escaping (BookNote)->()) {
        let note = BookNote(id: UUID(),
                            date: Date(),
                            label: noteType.rawValue,
                            content: contents)
        addBookNoteUseCase.execute(note,
                                   to: bookInfo,
                                   of: nil, completion)
    }
    
    //TODO: edit function
    func editItem(noteId: UUID, _ completion: @escaping (BookNote)->()) {
        let note = BookNote(id: noteId,
                            date: noteDate,
                            label: noteType.rawValue,
                            content: contents)
        updateBookNoteUseCase.execute(with: note, of: nil) { _ in
            completion(note)
        }
    }
}

