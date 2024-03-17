//
//  ReadingBookView.swift
//  ReadLog
//
//  Created by sanghyo on 11/21/23.
//

import SwiftUI
import CoreData

protocol RemoveReadingBookDelegate: AnyObject {
    func removeReadingBook(_ bookInfo: BookInfo)
}

struct ReadingBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var tab: Int
    @State var readingBooks: [BookInfo] = []
    @State var currentIndex: Int = 0
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    private let fetchBookListUseCase: FetchBookListUseCase
    
    init(tab: Binding<Int>, fetchBookListUseCase: FetchBookListUseCase = FetchBookListUseCaseImpl()) {
        self._tab = tab
        self.fetchBookListUseCase = fetchBookListUseCase
    }
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .topLeading) {
                Color.backgroundColor
                    .ignoresSafeArea()
                VStack{
                    //                    Text("읽고 있는 책 목록")
                    //                        .display(Color.black)
                    //                        .offset(y: 0)
                    Spacer().frame(maxHeight: 30)
                    
                    if (currentIndex != readingBooks.count){
                        Text("\(currentIndex + 1)권 / \(readingBooks.count)권")
                            .body2(Color.black)
                            .frame(width: 231, height: 21, alignment: .top)
                    } else {
                        Text("새로운 책을 추가해 보세요")
                            .body2(Color.black)
                            .frame(width: 231, height: 21, alignment: .top)
                    }
                    BooksView(tab: $tab, books: $readingBooks, currentIndex: $currentIndex)
                    
                    Spacer()
                        .frame(maxHeight: 20)
                    
                    HStack {
                        Text("독서 기록")
                            .title(Color.black)
                            .frame(width: 330, height: 21, alignment: .leading)
                            .padding(3)
                    }
                    Spacer()
                        .frame(height: windowScene?.windows.first?.safeAreaInsets.bottom == 0 ? 10 : 30)
                    VStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 332, height: 1)
                            .background(Color(red: 0.76, green: 0.76, blue: 0.76))
                        Spacer()
                        if readingBooks.indices.contains(currentIndex) {
                            let noteSet = readingBooks[currentIndex].notes
                                if !noteSet.isEmpty {
                                    VStack(alignment: .leading, spacing:8){
                                        HStack {
                                            Text(Date.yyyyMdFormatter.string(from: noteSet.first!.date!))
                                            
                                                .bodyDefaultMultiLine(Color("gray"))
                                                .foregroundColor(.secondary)
                                                .offset(x: 10)
                                            Spacer()
                                            //LabelView(text: memo.label)
                                            NoteLabel(type: .constant(convertNoteLabel(labelInt: Int(noteSet.first!.label))))
                                        }
                                        .frame(maxHeight: 30)
                                        
                                        Text(noteSet.first!.content ?? "책에 대한 기록이 아직 없어요.\n탭 해서 기록을 추가해 보세요")
                                            .bodyDefault(Color.primary)
                                            .frame(maxWidth: 330, maxHeight: 110)
                                            .offset(x: 10)
                                        
                                    }//where vstack ends
                                    .frame(width: 350)
                                } else {
                                    Text("책에 대한 기록이 아직 없어요.\n탭 해서 기록을 추가해 보세요")
                                        .bodyDefault(Color("gray"))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                            

                        }
                        else {
                            Text("새로운 책을 추가해 보세요")
                                .bodyDefault(Color("gray"))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 332, height: 1)
                            .background(Color(red: 0.76, green: 0.76, blue: 0.76))
                    }
                    .frame(maxWidth: 350, maxHeight: windowScene?.windows.first?.safeAreaInsets.bottom == 0 ? 130 : 190)
                    
                }
                
            }
        }
        .onAppear {
            // 나라 위치별 코드 test
            fetchBookListUseCase.readingBooks(of: nil) { bookList in
                readingBooks = bookList.reversed()
                print(readingBooks)
            }
        }
    }
    
    private func convertNoteLabel(labelInt: Int) -> NoteType {
        return labelInt == 0 ? .impressive : .myThink
    }
}

//#Preview {
//    ReadingBookView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
