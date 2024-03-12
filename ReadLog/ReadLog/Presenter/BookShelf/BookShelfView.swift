import SwiftUI
import CoreData

protocol AddReadBookDelegate: AnyObject {
    func removeFromReadBookList(_ bookInfo: BookInfo)
}

struct BookShelfView: View {
    @Environment(\.managedObjectContext) private var viewContext
    // 중복된 isbn에 대해서 한개만 뜨도록 설정
//    @FetchRequest (sortDescriptors:
//                    [NSSortDescriptor(keyPath: \ReadBookEntity.endDate, ascending: false)],
//                   animation: .default)
//    private var fetchedBookList: FetchedResults<ReadBookEntity>
    private let bookCountInRow: Int = 3
    private let rowInPage: Int = 3
    private var interpolatedBookList: [BookInfo?] {
        get {
            guard let fetchedBookList else { return [] }
            return interpolateBookList(fetchedBookList)
        }
    }
    @State private var fetchedBookList: [BookInfo]?
    private let fetchReadBookListUseCase: FetchReadBookListUseCase
    
    init(fetchReadBookListUseCase: FetchReadBookListUseCase = FetchReadBookListUseCaseImpl()) {
        self.fetchReadBookListUseCase = fetchReadBookListUseCase
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                VStack(spacing: 40) {
                    header
                    if interpolatedBookList.count == 0 {
                        Group {
                            Spacer()
                            Text("아직 읽은 책이 없어요")
                            Text("책을 읽고 책장에 전시해보세요")
                            Spacer()
                        }.body1(Color.darkGray)
                    } else {
                        TabView {
                            ForEach(0..<(interpolatedBookList.count-1) / (bookCountInRow * rowInPage) + 1, id:\.self) { page in // 책 1~9권까지는 1, 10~18까지는 2, ... 리턴
                                VStack {
                                    ForEach((page*rowInPage)..<(page+1)*rowInPage, id: \.self) {idx in // 각 페이지당 1~3번째 줄 가져옴
                                        if (idx < interpolatedBookList.count/bookCountInRow) {
                                            BookShelfCell(renderedBook: dataForRow(idx: idx))
                                        }
                                        else {
                                            Rectangle()
                                                .foregroundStyle(Color.clear)
                                                .frame(width: 380, height: 144)
                                            Rectangle()
                                                .foregroundStyle(Color.white)
                                                .frame(width: 380, height: 6)
                                                .shadow(radius: 4, y: 4)
                                                .padding(.bottom, 37)
                                        }
                                    }
                                }
                            }
                            .listStyle(.plain)
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 600)
                    }
                }
            }
            
            .toolbar(.hidden)
        }
        .onAppear {
            fetchReadBookListUseCase.execute(of: nil) { bookList in
                print("----")
                print(bookList)
                fetchedBookList = bookList
            }
            
        }
    }
}

private extension BookShelfView {
    var header: some View {
        HStack {
            Spacer()
            Text("읽은 책 목록")
                .display(Color.black)
            Spacer()
        }
        .tint(.black)
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
    }
    
    func interpolateBookList(_ bookList: [BookInfo]) -> [BookInfo?] {
        // 같은 책 1개만 가져올 수 있도록
        var readList: [BookInfo?] = []
//        for record in readList {
//            if !dictionary.keys.contains(record.isbn!) {
//                dictionary[record.isbn!] = true
//                bookList.append(record)
//            }
//        }
        for book in bookList {
            if !book.readbooks.isEmpty {
                readList.append(book)
            }
        }
        let bookCount = readList.count
        let addBookCount = (bookCountInRow - bookCount % bookCountInRow) % bookCountInRow
        let nilArray: [BookInfo?] = Array<BookInfo?>(repeating: nil, count: addBookCount)
        return bookList + nilArray
    }
    
    func dataForRow(idx: Int) -> [BookInfo?] {
        Array(interpolatedBookList[idx*bookCountInRow..<idx*bookCountInRow+3])
    }
}

#Preview {
    BookShelfView().environment(\.managedObjectContext,
            PersistenceController.preview.container.viewContext)
}
