//
//  ReadingBookView.swift
//  ReadLog
//
//  Created by sanghyo on 11/21/23.
//

import SwiftUI
import CoreData

struct ReadingBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var tab: Int
    
    // Book info
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ReadingList.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ReadingList.readtime, ascending: false)],
        predicate: NSPredicate(format:"recent == true"),
        animation: .default)
    private var items: FetchedResults<ReadingList>
    @State var currentIndex: Int = 0
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    
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
                    
                    if (currentIndex != items.count){
                        Text("\(currentIndex + 1)권 / \(items.count)권")
                            .body2(Color.black)
                            .frame(width: 231, height: 21, alignment: .top)
                    } else {
                        Text("새로운 책을 추가해 보세요")
                            .body2(Color.black)
                            .frame(width: 231, height: 21, alignment: .top)
                    }
                    
                    BooksView(tab: $tab, items: items, currentIndex: $currentIndex)
                    
                    Spacer()
                        .frame(maxHeight: 20)
                    
                    HStack {
                        Text("최근 기록")
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
                        if items.indices.contains(currentIndex) {
                            if let book = items[currentIndex].book{
                                if let readLog = book.readLog {
                                    if let swiftSet = readLog as? Set<ReadLog>, !swiftSet.isEmpty {
                                        VStack(alignment: .leading, spacing:8){
                                            HStack {
                                                Text("\(swiftSet.first!.date!, formatter: Self.memoDateFormatter)")
                                                    .bodyDefaultMultiLine(Color("gray"))
                                                    .foregroundColor(.secondary)
                                                    .offset(x: 10)
                                                Spacer()
                                                //LabelView(text: memo.label)
                                                NoteLabel(type: .constant(convertNoteLabel(labelInt: Int(swiftSet.first!.label))))
                                            }
                                            .frame(maxHeight: 30)
                                            
                                            Text(swiftSet.first!.log!)
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
        }
    }
    
    static let memoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    private func convertNoteLabel(labelInt: Int) -> Note {
        return labelInt == 0 ? .impressive : .myThink
    }
    
}
//#Preview {
//    ReadingBookView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
