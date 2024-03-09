//
//  BookInfoView.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI
import CoreData

struct BookInfoView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tab: Int
    
    // core data
    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        sortDescriptors: [
//            NSSortDescriptor(keyPath: \BookInfoEntity.id, ascending: false)
//        ],
//        animation: .default
//    )
//    private var dbBookData: FetchedResults<BookInfoEntity>
    private let fetchBookInfoUseCase: FetchBookInfoUseCase
    private let addBookInfoUseCase: AddBookInfoUseCase
    private let updateBookInfoUseCase: UpdateBookInfoUseCase
    @State private var dbBookData: BookInfo?
    // view variables
    var bookInfo: BookInfo
    
    @State var bookWithPage: BookInfoData?
    @State var like = false
    @State var buttonText = "독서 시작"
    
    @Environment(\.openURL) var openURL
    
    init(tab: Binding<Int>,
         bookInfo: BookInfo,
         fetchBookInfoUseCase: FetchBookInfoUseCase = FetchBookInfoUseCaseImpl(),
         addBookInfoUseCase: AddBookInfoUseCase = AddBookInfoUseCaseImpl(),
         updateBookInfoUseCase: UpdateBookInfoUseCase = UpdateBookInfoUseCaseImpl()) {
        self._tab = tab
        self.bookInfo = bookInfo
        self.fetchBookInfoUseCase = fetchBookInfoUseCase
        self.addBookInfoUseCase = addBookInfoUseCase
        self.updateBookInfoUseCase = updateBookInfoUseCase
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    header
                    ScrollView {
                        BookProfileContainer(bookInfo: bookInfo)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Text("책 소개")
                                .title(.black)
                            Spacer()
                            Button {
                                print("move to book purchase link")
                                openURL(URL(string: bookInfo.link)!)
                            } label: {
                                Image(systemName: "link")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        
                        Divider()
                        
                        Text(bookInfo.bookDescription)
                            .bodyDefaultMultiLine(.black)
                            .padding(.vertical, 15)
                            .padding(.horizontal)
                            .lineSpacing(20)
                    }
                    
                    Spacer()
                    
                    Divider()
                    
                    HStack {
                        Button {
                            print("add/delete from wishlist")
                            like.toggle()
                        } label: {
                            Image(systemName: like ? "heart.fill" : "heart")
                                .foregroundColor(.customPink)
                                .font(.system(size: 35))
                        }
                        
                        // book data does not exist in core data
                        if buttonText == "독서 시작" {
                            Button {
                                print("start to read the book.")
                                // TODO: isbn 없는 경우 핸들링 코드 전체적으로 작성 필요
                                fetchBookInfoUseCase.execute(with: bookInfo.isbn!) { book in
                                    if let book {
                                        // 책을 읽은 적 있는 경우
                                        if bookInfo.page != 0 {
                                            // save to core data
//                                            saveBookData(newBook: book)
                                            addToReadingList(newBook: book)
                                            // add To Reading List에서 pinned, recent 해주는 작업 필요없음. saveBookData에서 readingStatus True 해주면
                                            //TODO: 첫번째 페이지에서 bookinfo 중에 readingStatus true인 값 가져오는 로직으로 변경
                                        } else {
                                            // call isbn search api and take subinfo data
                                            // save data to core data
                                            getBookDataWithPage(isbn: bookInfo.isbn!) { result in
                                                if let bookWithPage = result {
//                                                    saveBookData(newBook: bookWithPage)
                                                    addToReadingList(newBook: bookWithPage)
                                                }
                                            }
                                        }
                                    } else {
                                        // 책을 읽은 적 없는 경우
                                        saveBookData(newBook: bookInfo)
                                    }
                                }
//                                dbBookData.nsPredicate = NSPredicate(format: "id == %d", Int32(bookInfo.id))
//                                if dbBookData.isEmpty {
//                                    // if bookInfo object has page number, api call is not required.
//                                    if bookInfo.itemPage != 0 {
//                                        // save to core data
//                                        saveBookData(newBook: bookInfo)
//                                        addToReadingList(bookId: Int32(bookInfo.id))
//                                        // add To Reading List에서 pinned, recent 해주는 작업 필요없음. saveBookData에서 readingStatus True 해주면
//                                        //TODO: 첫번째 페이지에서 bookinfo 중에 readingStatus true인 값 가져오는 로직으로 변경
//                                    } else {
//                                        // call isbn search api and take subinfo data
//                                        // save data to core data
//                                        getBookDataWithPage(isbn: bookInfo.isbn) { result in
//                                            if let bookWithPage = result {
//                                                saveBookData(newBook: bookWithPage)
//                                                addToReadingList(bookId: Int32(bookWithPage.id))
//                                            }
//                                        }
//                                    }
//                                } else {
//                                    addToReadingList(bookId: Int32(bookInfo.id))
//                                }
                                
                            } label: {
                                Text(buttonText)
                                    .title(.black)
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.vertical, 10)
                            .foregroundColor(.black)
                            .background(Color.lightBlue)
                            .cornerRadius(5.0)
                        } else {
                            
                            // todomain 부분 수정한거임 나중에 다시 수정
                            NavigationLink(destination: BookDetailFull(dbBookData, isRead: false).navigationBarBackButtonHidden(true)) {
                                
                                
                                Button {
                                    print("go to book detail page.")
                                } label: {
                                    Text(buttonText)
                                        .title(.black)
                                        .frame(maxWidth: .infinity)
                                }
                                .padding(.vertical, 10)
                                .foregroundColor(.black)
                                .background(Color.lightBlue)
                                .cornerRadius(5.0)
                                .disabled(true)
                            }
                        }
                    }
                    .padding(.top, 7)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                }
            }
        }
        .onAppear {
            fetchBookInfoUseCase.execute(with: bookInfo.isbn!) { bookInfo in
                guard let bookInfo else { return }
                dbBookData = bookInfo
                self.like = bookInfo.wish
                if bookInfo.readingStatus {
                    self.buttonText = "독서 진행 중"
                }
            }
//            dbBookData.nsPredicate = NSPredicate(format: "id == %d", Int32(bookInfo.id))
//            if !dbBookData.isEmpty {
//                self.like = dbBookData.first!.wish
//                if dbBookData.first!.readingStatus {
//                    self.buttonText = "독서 진행 중"
//                }
                /*
                if let readingList = dbBookData.first!.readingTrackings as? Set<ReadingTrackingEntity> {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                    
                    // TODO: 가장 처음 책을 읽기 시작한 날 buttonText에 넣는 로직으로 변경
//                    let recent = readingList.filter { $0.recent == true }
//                    
//                    if !recent.isEmpty {
//                        self.buttonText = dateFormatter.string(from: recent.first!.readtime!)
//                    }
                    self.buttonText = "독서 진행 중"
                    
                }
                 */
//            }
        }
        .onDisappear {
            // save wishlist changes
            // if book data is not in db and added to wishlist, saves book data (wish = true)
            // if book data is in db, save changes
            fetchBookInfoUseCase.execute(with: bookInfo.isbn!) { book in
                if let book {
                    if like != book.wish {
                        guard var dbBookData else { return }
                        dbBookData.wish = like
                        updateBookInfoUseCase.execute(book: dbBookData, of: nil, nil)
                    }
                } else {
                    if like {
                        if bookInfo.page == 0 {
                            getBookDataWithPage(isbn: bookInfo.isbn!) { result in
                                if let bookWithPage = result {
                                    saveBookData(newBook: bookWithPage)
                                }
                            }
                        } else {
                            saveBookData(newBook: bookInfo)
                        }
                    }
                }
                
                
            }
            
//            dbBookData.nsPredicate = NSPredicate(format: "id == %d", Int32(bookInfo.id))
//            if dbBookData.isEmpty {
//                if like {
//                    if bookInfo.itemPage == 0 {
//                        getBookDataWithPage(isbn: bookInfo.isbn) { result in
//                            if let bookWithPage = result {
//                                saveBookData(newBook: bookWithPage)
//                            }
//                        }
//                    } else {
//                        saveBookData(newBook: bookInfo)
//                    }
//                }
//            } else {
//                if like != dbBookData.first!.wish {
//                    updateBookWish(bookId: Int32(bookInfo.id))
//                }
//            }
        }
    }
    
    private func getBookDataWithPage(isbn: String, completion: @escaping (BookInfo?) -> Void) {
        let requestUrl = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=\(ApiKey.aladinKey)&itemIdType=ISBN13&ItemId=\(isbn)&output=js&Version=20131101"
        
        guard let url = URL(string: requestUrl) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let decodedData = try decoder.decode(JsonResponse.self, from: data)
                
                DispatchQueue.main.async {
                    print(decodedData.item.count)
                    
                    let bookDataArray: [BookInfo] = decodedData.item.map { bookJson in
                        if let itemPage = bookJson.subInfo?.itemPage {
                            return mappingToBookInfo(bookDataJsonResponse: bookJson, page: itemPage)
                        } else {
                            return mappingToBookInfo(bookDataJsonResponse: bookJson, page: 0)
                        }
                    }
                    
                    if let bookWithPage = bookDataArray.first {
                        completion(bookWithPage)
                    } else {
                        completion(nil)
                    }
                    
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    /*
    func findBook(bookId: Int32) -> BookInfoEntity? {
        let fetchRequest: NSFetchRequest<BookInfoEntity> = BookInfoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", bookId)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error fetching object by id: \(error)")
            return nil
        }
    }
    */
    private func mappingToBookInfo(bookDataJsonResponse: BookDataJsonResponse, page: Int) -> BookInfo {
        var bookInfo = BookInfo(id: bookDataJsonResponse.id,
                                author: bookDataJsonResponse.author,
                                bookDescription: bookDataJsonResponse.description,
                                coverImageUrl: bookDataJsonResponse.coverImage,
                                image: nil,
                                isbn: bookDataJsonResponse.isbn,
                                link: bookDataJsonResponse.link,
                                readingStatus: false,
                                repeatTime: 0,
                                page: page,
                                pinned: false,
                                publisher: bookDataJsonResponse.publisher,
                                title: bookDataJsonResponse.title,
                                wish: false,
                                notes: [],
                                trackings: [],
                                readbooks: [])
        
        fetchImage(urlString: bookDataJsonResponse.coverImage) { imageData in
            DispatchQueue.main.async {
                if let imageData {
                    bookInfo.image = UIImage(data: imageData)
                } else {
                    print("Failed to fetch or convert image data.")
                }
            }
        }
        
        return bookInfo
    }
    
    private func saveBookData(newBook: BookInfo) {
        print("Save book to core data.")
        addBookInfoUseCase.execute(book: newBook)
    }
    
    
    private func addToReadingList(newBook: BookInfo) {
        var book = newBook
        book.readingStatus = true
        updateBookInfoUseCase.execute(book: book, of: nil) { _ in
            print("saved readingList to db")
            self.buttonText = "독서 진행중"
            // reading book view delegate 작업
            // tab 바꾸는것도 delegate에서
        }
        
//        guard let book = findBook(bookId: bookId) else {
//            return
//        }
//        book.readingStatus = true
//        
//        let newReading = ReadingTrackingEntity(context: viewContext)
//        newReading.readDate = Date()
//        newReading.readPage = 0
//        
//        book.readingTrackings = [newReading]
//        newReading.bookInfo = book
        
//        do {
//            try viewContext.save()
//            print("saved readingList to db")
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
//            self.buttonText = dateFormatter.string(from: newReading.readDate!)
//            self.buttonText = "독서 진행 중"
//            tab = 0
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
    }
    /*
    func updateBookWish(bookId: Int32) {
        guard let book = findBook(bookId: bookId) else {
            return
        }
        
        book.wish = like
        
        do {
            try viewContext.save()
            print("updated book in db")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    */
    // 다른 파일에서도 사용되기 때문에 dto -> domain mapper로 만들어도 좋을 듯
    private func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        let convertedUrl = urlString.replacingOccurrences(of: "coversum", with: "cover200")
        
        guard let url = URL(string: convertedUrl) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
        
        task.resume()
    }
}

private extension BookInfoView {
    var header: some View {
        ZStack {
            HStack {
                Spacer()
                Text("책 정보")
                    .display(Color.black)
                Spacer()
                
            }
            .tint(.black)
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
            
            HStack {
                Button(action:{
                    self.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.primary)
                }
                
                Spacer()
            }
            .padding(.leading, 16)
        }
        
    }
}
