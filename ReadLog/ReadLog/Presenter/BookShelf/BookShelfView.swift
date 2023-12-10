import SwiftUI

struct BookShelfView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest (sortDescriptors:
                    [NSSortDescriptor(keyPath: \ReadList.enddate, ascending: false)], predicate:  NSPredicate(format: "recent == true" ),
                   animation: .default)
    private var fetchedBookList: FetchedResults<ReadList>
    private let bookCountInRow: Int = 3
    private let rowInPage: Int = 3
    private var interpolatedBookList: [BookInfo?] {
        get {
            return interpolateBookList(fetchedBookList)
        }
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
                            ForEach(0..<interpolatedBookList.count/bookCountInRow/rowInPage+1, id:\.self) { page in
                                VStack {
                                    ForEach((page*rowInPage)..<(page+1)*rowInPage, id: \.self) {idx in
                                        if (idx < interpolatedBookList.count/bookCountInRow) {
                                            BookShelfCell(renderedBook: dataForRow(idx: idx))
                                        }
                                        else {
                                            Spacer()
                                                .frame(height: 202.5)
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
    
    func interpolateBookList(_ readList: FetchedResults<ReadList>) -> [BookInfo?] {
        let bookCount = readList.count
        let addBookCount = (bookCountInRow - bookCount % bookCountInRow) % bookCountInRow
        let nilArray: [BookInfo?] = Array<BookInfo?>(repeating: nil, count: addBookCount)
        let bookList = readList.map {readRecord in
            return readRecord.book }
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
