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
    
    // Book info
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ReadingList.pinned, ascending: false),
            NSSortDescriptor(keyPath: \ReadingList.readtime, ascending: false)],
        predicate: NSPredicate(format: "recent == true"),
        animation: .default)
    private var items: FetchedResults<ReadingList>
    
    // Carousel View
    let visibleEdgeSpace: CGFloat = 38 // 옆 화면의 일부가 얼마나 보이는지
    let spacing: CGFloat = 28 // 뷰 사이의 공간 크기
    @GestureState var dragOffset: CGFloat = 0 // 손가락으로 page를 넘기는 정도
    @State var currentIndex: Int = 0 // 현재 가리키는 page넘버
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                VStack{
                    Text("읽고 있는 책 목록")
                        .font(Font.custom("omyu pretty", size: 24)
                        .weight(.semibold)
                        )
                    
                    .foregroundColor(.black)
                    Text("0권 / \(items.count)권")
                        .font(Font.custom("omyu pretty", size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 231, height: 21, alignment: .top)
                    
                    GeometryReader { proxy in
                        let baseOffset: CGFloat = spacing + visibleEdgeSpace
                        let pageWidth: CGFloat = proxy.size.width - (visibleEdgeSpace + spacing) * 2
                        let offsetX: CGFloat = baseOffset - CGFloat(currentIndex) * (pageWidth + spacing) + dragOffset
                        
                        HStack(spacing: spacing) {
                            ForEach(items, id: \.self) { item in
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(
                                            width: pageWidth,
                                            height: proxy.size.height)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 5)
                                    VStack{
                                        Text(item.book!.isbn!)
                                    }
                                    .frame(alignment: .center)
                                }
                            }
                            NavigationLink(destination: BookSearchView()) {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(
                                            width: pageWidth,
                                            height: proxy.size.height)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 5)
                                    Image("simple-line-icons:plus")
                                        .frame(width: 70, height: 70)
                                }
                            }
                        }
                        .offset(x: offsetX)
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, out, _ in
                                    out = value.translation.width
                                }
                                .onEnded { value in
                                    let offsetX = value.translation.width
                                    let progress = -offsetX / pageWidth
                                    let increment = Int(progress.rounded())
                                    
                                    currentIndex = max(min(currentIndex + increment, items.count), 0)
                                }
                        )
                    }
                    .frame(height: 328)
                    .padding(.vertical, 15)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack{
                        Text("최근 기록")
                            .font(Font.custom("omyu pretty", size: 22))
                            .foregroundColor(.black)
                            .frame(width: 330, height: 21, alignment: .leading)
                            .padding(3)
                    }
                    VStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 332, height: 1)
                            .background(Color(red: 0.76, green: 0.76, blue: 0.76))
                        Spacer()
                        if items.indices.contains(currentIndex) {
                            if let readLog = items[currentIndex].book!.readLog {
                                if let swiftSet = readLog as? Set<ReadLog>, !swiftSet.isEmpty {
                                    VStack(alignment: .leading, spacing:8){
                                        HStack {
                                            Text("\(swiftSet.first!.date!, formatter: Self.memoDateFormatter)")
                                                .bodyDefault(Color("gray"))
                                                .foregroundColor(.secondary)
                                                .offset(x: 15)
                                            Spacer()
                                            //LabelView(text: memo.label)
                                            NoteLabel(.impressive)
                                        }
                                        .frame(height: 30)
                                        
                                        Text(swiftSet.first!.log!)
                                            .bodyDefault(Color.primary)
                                            .frame(width: 330, height: 110)
                                            .offset(x: 10)
                                        
                                    }//where vstack ends
                                    .frame(width: 350)
                                } else {
                                    Text("책에 대한 기록이 아직 없어요.\n\n탭 해서 기록을 추가해 보세요")
                                        .font(Font.custom("omyu pretty", size: 20))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
                                }
                            }
                        }
                        else {
                            Text("새로운 책을 추가해 보세요")
                                .font(Font.custom("omyu pretty", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
                        }
                        Spacer()
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 332, height: 1)
                            .background(Color(red: 0.76, green: 0.76, blue: 0.76))
                    }
                    .frame(width: 350, height: 190)
                    
                }
                
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newBook = BookInfo(context:viewContext)
            newBook.isbn = "add"
            
            let newReading = ReadingList(context: viewContext)
            newReading.recent = true
            newReading.pinned = false
            newReading.readtime = Date()
            newReading.book = newBook
            
            if var curReadingList = newBook.readingList {
                curReadingList = curReadingList.adding(newReading) as NSSet
                newBook.readingList = curReadingList
            } else {
                newBook.readingList = [newReading]
            }

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    static let memoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
}
#Preview {
    ReadingBookView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
