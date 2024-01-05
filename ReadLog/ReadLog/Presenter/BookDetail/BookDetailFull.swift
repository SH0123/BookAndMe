//
//  BookDetailFull.swift
//  ReadLog
//
//  Created by 이만 on 2023/11/21.
//

import SwiftUI
import CoreData

struct BookDetailFull: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ReadingTrackerViewModel 
    @State private var pagesReadInput: String = ""
    @State private var bookMemos: [ReadLog] = []
    @State private var showingAlert: Bool = false
    @State private var isInit: Bool = true
    @FocusState private var isInputActive: Bool
    private var bookInfo: BookInfo?
    private var isRead: Bool = false
    let memoDateFormatter: DateFormatter = Date.yyyyMdFormatter
    
    init(_ bookInfo: BookInfo?, isRead: Bool) {
        self.bookInfo = bookInfo
        self.isRead = isRead
        self._viewModel = StateObject(wrappedValue: ReadingTrackerViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
            VStack {
                header
                ScrollView {
                    displayBook(isbn: (self.bookInfo?.isbn)!)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 40, trailing: 0))
                    if !isRead {
                        HStack {
                            Spacer()
                            Text("\(viewModel.lastPageRead)p / \(viewModel.totalBookPages)p")
                                .mini(.black)
                        }
                        progressBar(value: viewModel.progressPercentage)
                        Spacer(minLength: 20)
//                        trackingCircles(viewModel: self.viewModel)
                    }
                    Spacer(minLength: 20)
                    HStack{
                        VStack(alignment: .leading){
                            Text("독서 기록").title(Color.primary)
                            HStack {
                                Text("어떤 부분이 인상 깊었나요?").bodyDefault(Color.primary)
                                Spacer()
                                NavigationLink(destination:AddNoteView(bookInfo!, $bookMemos)){
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 24, height: 24)
                                }
                                .foregroundStyle(Color.primary)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5))
                    .background(Color("backgroundColor"))
                    Divider()
                    bookNoteView(memos: bookMemos)
                }
                .scrollIndicators(.hidden)
                if !isRead {
                    pageInput
                }
            }
            .padding(.horizontal)
            .background(Color("backgroundColor"))
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        if let newPageRead = Int(pagesReadInput), newPageRead > viewModel.lastPageRead, newPageRead <= viewModel.totalBookPages {
                            viewModel.addDailyProgress(newPageRead: newPageRead, bookInfo: self.bookInfo!)
                            pagesReadInput = ""
                            hideKeyboard()
                        } else {
                            showingAlert = true
                        }
                    } label: {
                        Text("저장")
                            .foregroundStyle(Color.black)
                    }
                }
                
            }
            .alert("숫자 형식이 올바르지 않습니다.", isPresented: $showingAlert) {
                Button("확인") {
                    pagesReadInput = ""
                }
            }
        
        .onTapGesture {
            isInputActive = false
        }
        .onAppear(perform: {
            if isInit {
                viewModel.setTotalBookPages(isbn: bookInfo!.isbn!, page: Int((bookInfo?.page)!))
                isInit = false
            }
            bookMemos = fetchAllBookNotes(isbn: bookInfo?.isbn)
        })
    }
}
// function
private extension BookDetailFull {
    func fetchBookInfo(isbn: String) -> BookInfo? {
        let fetchRequest: NSFetchRequest<BookInfo>
        
        fetchRequest = BookInfo.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "isbn LIKE %@", isbn)
        
        do {
            let object = try viewContext.fetch(fetchRequest)
            return object.first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func fetchAllBookNotes(isbn: String?) -> [ReadLog] {
        guard let isbn else { return [] }
        let fetchRequest: NSFetchRequest<ReadLog>
        
        fetchRequest = ReadLog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K LIKE %@",#keyPath(ReadLog.book.isbn), isbn)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func fetchAllReadingList(isbn: String) -> [ReadingList] {
        let fetchRequest: NSFetchRequest<ReadingList>
        
        fetchRequest = ReadingList.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ReadingList.readtime, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "book.isbn LIKE %@",isbn)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func deleteAllReadList(readingList: [ReadingList]) {
        for idx in 0..<readingList.count {
            viewContext.delete(readingList[idx])
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
        
    }
    
    func addReadList(entity: BookInfo, sdate: Date, edate: Date) {
        let readBook = ReadList(context: viewContext)
        readBook.id = UUID()
        readBook.startdate = sdate
        readBook.enddate = edate
        readBook.book = entity
        
        if var readList = bookInfo?.readList {
            readList = readList.adding(readBook) as NSSet
            bookInfo?.readList = readList
        } else {
            bookInfo?.readList = [readBook]
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func readComplete(isbn: String?) {
        guard let isbn else { return }
        // fetch start, end date
        let startDate: Date
        let endDate: Date
        let readingList = fetchAllReadingList(isbn: isbn)
        if readingList.isEmpty {
            return
        }
        
        //TODO: date handling
        startDate = readingList.first?.readtime ?? Date()
        endDate = readingList.last?.readtime ?? Date()
        
        // delete all reading list
        deleteAllReadList(readingList: readingList)
        
        // add read list
        if let bookInfo {
            addReadList(entity: bookInfo, sdate: startDate, edate: endDate)
        }
    }
}

// MARK: - 책 정보 뷰
private extension BookDetailFull {
    @ViewBuilder
    func displayBook(isbn: String) -> some View {
        if let book = fetchBookInfo(isbn: isbn) {
            VStack {
                HStack{
                    if let imageData = book.image, let uiImage = UIImage(data:imageData){
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .clipped()
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                    }else{
                        Image(systemName: "book")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .clipped()
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                    }
                    VStack(alignment: .leading){
                        Text(book.title ?? "Unknown Title")
                            .body2(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 6)
                        Text(book.author ?? "Unknown Author")
                            .mini(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 6)
                        Text(book.publisher ?? "Unknown Publisher")
                            .mini(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 6)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius:10)
                    .stroke(Color("gray"), lineWidth: 1)
                )
            }
        }else{
            Text("Book not found").title(Color.primary)
        }
    }
}

// MARK: - progress view
private extension BookDetailFull {
    func progressBar(value: Double) -> some View {
        let thickness: CGFloat = 15
        
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: thickness)
                    .opacity(0.3)
                    .foregroundColor(Color("gray"))
                
                Rectangle().frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: thickness)
                    .foregroundColor(Color("lightBlue"))
                    .animation(.linear, value: value)
            }
            .clipShape(RoundedRectangle(cornerRadius: 45))
        }
        .frame(height: 15)
    }
}

// MARK: - Daily Tracking view
private extension BookDetailFull {
    struct trackingCircles: View {
        @StateObject var viewModel: ReadingTrackerViewModel
        var body: some View {
            HStack {
                ForEach(viewModel.dailyProgress) { progress in
                    Circle()
                        .fill(progress.pagesRead > 0 ? Color("lightBlue") : Color("gray"))
                        .frame(width: 45, height: 45)
                        .overlay(Text("\(progress.pagesRead)p"))
                        .body3(Color.primary)
                }
            }
        }
    }
}

//MARK: - Book Note view
private extension BookDetailFull {
    @ViewBuilder
    func bookNoteView(memos: [ReadLog]) -> some View {
        if !memos.isEmpty {
            LazyVStack {
                ForEach(memos) { memo in
                    bookNote(memo: memo)
                }
            }
        } else {
            Text("저장된 노트가 없습니다.")
                .bodyDefault(Color("gray"))
        }
    }
    
    func bookNote(memo: ReadLog) -> some View {
        VStack {
            VStack(alignment: .leading, spacing:10) {
                HStack {
                    Text(memoDateFormatter.string(from: memo.date!))
                        .bodyDefault(Color("gray"))
                        .foregroundColor(.secondary)
                    Spacer()
                    NoteLabel(type: .constant(convertLabel(labelType: Int(memo.label))))
                }
                Text(memo.log ?? "")
                    .bodyDefaultMultiLine(Color.primary)
            }
            .padding(.vertical, 10)
            Divider()
        }
    }
    
    func convertLabel(labelType: Int) -> Note {
        return labelType == 0 ? .impressive : .myThink
    }
}

// MARK: - today page input view
private extension BookDetailFull {
    var pageInput: some View {
        HStack {
            Text("어디까지 읽으셨나요?")
                .body1(Color.primary)
            Spacer()
            TextField("페이지 번호...", text: $pagesReadInput)
                .frame(width:120, height: 37)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(isInputActive ? .black : Color("gray")).body2(Color.primary)
                .focused($isInputActive)
        }
        .padding()
        .frame(height:47)
        .background(Color("lightBlue"),in: RoundedRectangle(cornerRadius: 10))
    }
}

private extension BookDetailFull {
    var header: some View {
        HStack {
            Button(action:{
                self.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.primary)
            }
            Spacer()
            if !isRead {
                Button("완독"){
                    readComplete(isbn: bookInfo?.isbn)
                    dismiss()
                }
                .body1(Color.primary)
            } else {
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
    }

}
//#Preview {
//    BookDetailFull("newBook3")
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
