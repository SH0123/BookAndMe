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
    @State private var bookMemos: [BookNote] = []
    @State private var showingAlert: Bool = false
    @State private var isInit: Bool = true
    @FocusState private var isInputActive: Bool
    private let fetchBookInfoUseCase: FetchBookInfoUseCase
    private let fetchBookNoteListUseCase: FetchBookNoteListUseCase
    private let updateBookInfoUseCase: UpdateBookInfoUseCase
    private let fetchReadingTrackingsUseCase: FetchReadingTrackingsUseCase
    private var bookInfo: BookInfo?
    private var isRead: Bool = false
    let memoDateFormatter: DateFormatter = Date.yyyyMdFormatter
    
    init(_ bookInfo: BookInfo?, 
         isRead: Bool,
         fetchBookInfoUseCase: FetchBookInfoUseCase = FetchBookInfoUseCaseImpl(),
         fetchBookNoteListUseCase: FetchBookNoteListUseCase = FetchBookNoteListUseCaseImpl(),
         updateBookInfoUseCase: UpdateBookInfoUseCase = UpdateBookInfoUseCaseImpl(),
         fetchReadingTrackingsUseCase: FetchReadingTrackingsUseCase = FetchReadingTrackingsUseCaseImpl()
    ) {
        self.bookInfo = bookInfo
        self.isRead = isRead
        self._viewModel = StateObject(wrappedValue: ReadingTrackerViewModel(context: PersistenceController.shared.container.viewContext))
        self.fetchBookInfoUseCase = fetchBookInfoUseCase
        self.fetchBookNoteListUseCase = fetchBookNoteListUseCase
        self.updateBookInfoUseCase = updateBookInfoUseCase
        self.fetchReadingTrackingsUseCase = fetchReadingTrackingsUseCase
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
                        if let newPageRead = Int(pagesReadInput), newPageRead <= viewModel.totalBookPages {
                            // TODO: 여기 제대로 동작 안함
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
            .alert("유효 하지 않은 페이지 입니다.", isPresented: $showingAlert) {
                Button("확인") {
                    pagesReadInput = ""
                    showingAlert = false
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
            fetchAllBookNotes(isbn: bookInfo?.isbn) { notes in
                bookMemos = notes
            }
        })
    }
}
// function
private extension BookDetailFull {
    func fetchBookInfo(isbn: String, _ completion: @escaping (BookInfo?)->Void) {
        fetchBookInfoUseCase.execute(with: isbn) { bookInfo in
            completion(bookInfo)
        }
//        let fetchRequest: NSFetchRequest<BookInfoEntity>
//        
//        fetchRequest = BookInfoEntity.fetchRequest()
//        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "isbn LIKE %@", isbn)
//        
//        do {
//            let object = try viewContext.fetch(fetchRequest)
//            return object.first
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved Error\(nsError)")
//        }
    }
    
    func fetchAllBookNotes(isbn: String?, _ completion: @escaping ([BookNote])->Void) {
        guard let isbn else { return }
        fetchBookNoteListUseCase.execute(with: isbn, of: nil) { notes in
            completion(notes)
        }
        /*
        guard let isbn else { return [] }
        let fetchRequest: NSFetchRequest<BookNoteEntity>
        
        fetchRequest = BookNoteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K LIKE %@",#keyPath(BookNoteEntity.bookInfo.isbn), isbn)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
         */
    }
    
    func fetchAllReadingList(isbn: String, _ completion: @escaping ([ReadingTracking])->Void){
        fetchReadingTrackingsUseCase.execute(with: isbn, of: nil) { readingTrackings in
            completion(readingTrackings)
        }
    }
    // 필요 x
    /*
    func deleteAllReadList(readingList: [ReadingTrackingEntity]) {
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
    
    func doneReadingBook(entity: BookInfoEntity) {
        entity.readingStatus = false
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
        
        // delegate 사용 필요
    }
     */
    
    func readingStateToggle(book: BookInfo) {
        // delegate 사용 필요 bookshelf에 추가
        // delegate 사용 필요 readingList에서 제거
        var updateBook = book
        updateBook.readingStatus = false
        updateBookInfoUseCase.execute(book: updateBook, of: nil, nil)
    }
    
    func addReadList(book: BookInfo, sdate: Date, edate: Date) {
        let readBook = ReadBook(id: UUID(), startDate: sdate, endDate: edate)
//        addReadBookUseCase.execute(readBook: readBook, bookInfo: book, of: nil) { bookInfo in
//            readingStateToggle(book: bookInfo)
//            // 1번 탭에서 책 정보 지워줄 delegate 필요
//        }
        var newBook = book
        newBook.readbooks.append(readBook)
        updateBookInfoUseCase.execute(book: newBook, of: nil) { bookInfo in
            readingStateToggle(book: bookInfo)
        }
    }
    
    // bookShelf 추가 안됨
    func readComplete(isbn: String?) {
        guard let isbn else { return }
        // TODO: 이러면 다회독 했을 때 예전 데이터가 reading list에서 가져와져서 그 값이 저장될 듯
        fetchAllReadingList(isbn: isbn) { readingList in
            print(readingList)
            if readingList.isEmpty {
                return
            }
            
            let startDate = readingList.first?.readDate ?? Date()
            let endDate = readingList.last?.readDate ?? Date()
            
            // add read list
            if let bookInfo {
                // done read 이런 느낌의 함수 호출하고 > 내부에서 addreadlist, state toggle 하기
                addReadList(book: bookInfo, sdate: startDate, edate: endDate)
            }
        }
    }
}

// MARK: - 책 정보 뷰
private extension BookDetailFull {
    @ViewBuilder
    func displayBook(isbn: String) -> some View {
        if let book = bookInfo {
            VStack {
                HStack{
                    Image(uiImage: (book.image ?? UIImage(named: "noImage"))!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .clipped()
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                    }
                    VStack(alignment: .leading){
                        Text(book.title)
                            .body2(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 6)
                        Text(book.author)
                            .mini(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 6)
                        Text(book.publisher)
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
            } else{
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

//MARK: - Book Note view
private extension BookDetailFull {
    @ViewBuilder
    func bookNoteView(memos: [BookNote]) -> some View {
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
    
    func bookNote(memo: BookNote) -> some View {
        VStack {
            VStack(alignment: .leading, spacing:10) {
                HStack {
                    Text(memoDateFormatter.string(from: memo.date!))
                        .bodyDefault(Color("gray"))
                        .foregroundColor(.secondary)
                    Spacer()
                    NoteLabel(type: .constant(convertLabel(labelType: Int(memo.label))))
                }
                Text(memo.content ?? "")
                    .bodyDefaultMultiLine(Color.primary)
            }
            .padding(.vertical, 10)
            Divider()
        }
    }
    
    func convertLabel(labelType: Int) -> NoteType {
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
                    // delegate 통해서 1번탭에서 지워줄 것
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
