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
    private let fetchBookInfoUseCase: FetchBookInfoUseCase
    private let addBookInfoUseCase: AddBookInfoUseCase
    private let updateBookInfoUseCase: UpdateBookInfoUseCase
    private let addReadingTrackingUseCase: AddReadingTrackingUseCase
//    private weak var addWishListDelegate: AddWishListDelegate?
//    private weak var removeWishListDelegate: RemoveWishListDelegate?
    @State private var dbBookData: BookInfo?

    var bookInfo: BookInfo
    
    @State var bookWithPage: BookInfoData?
    @State var like = false
    @State var buttonText = "독서 시작"
    
    @Environment(\.openURL) var openURL
    
    init(tab: Binding<Int>,
         bookInfo: BookInfo,
         fetchBookInfoUseCase: FetchBookInfoUseCase = FetchBookInfoUseCaseImpl(),
         addBookInfoUseCase: AddBookInfoUseCase = AddBookInfoUseCaseImpl(),
         updateBookInfoUseCase: UpdateBookInfoUseCase = UpdateBookInfoUseCaseImpl(),
         addReadingTrackingUseCase: AddReadingTrackingUseCase = AddReadingTrackingUseCaseImpl()
//         addWishListDelegate: AddWishListDelegate?,
//         removeWishListDelegate: RemoveWishListDelegate?
    ) {
        self._tab = tab
        self.bookInfo = bookInfo
        self.fetchBookInfoUseCase = fetchBookInfoUseCase
        self.addBookInfoUseCase = addBookInfoUseCase
        self.updateBookInfoUseCase = updateBookInfoUseCase
        self.addReadingTrackingUseCase = addReadingTrackingUseCase
//        self.addWishListDelegate = addWishListDelegate
//        self.removeWishListDelegate = removeWishListDelegate
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
                        
                        if buttonText == "독서 시작" {
                            Button {
                                print("start to read the book.")
                                // TODO: isbn 없는 경우 핸들링 코드 전체적으로 작성 필요
                                fetchBookInfoUseCase.execute(with: bookInfo.isbn!) { book in
                                    addToReadingList(newBook: book)
                                }
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
        }
        .onDisappear {
            // save wishlist changes
            // if book data is not in db and added to wishlist, saves book data (wish = true)
            // if book data is in db, save changes
            // TODO: delegate 통해서 wishlist에 넣기
            fetchBookInfoUseCase.execute(with: bookInfo.isbn!) { book in
                // TODO: bookInfo, dbBookData 등 너무 많은 변수 존재해서 혼란을 야기
                if let book {
                    if like != book.wish {
                        guard var dbBookData else { return }
                        dbBookData.wish = like
                        updateBookInfoUseCase.execute(book: dbBookData, of: nil, nil)
                    }
                } else {
                    if like {
                        if dbBookData?.page == 0 {
                            getBookDataWithPage(isbn: bookInfo.isbn!) { result in
                                if var bookWithPage = result {

                                    bookWithPage.wish = true
                                    saveBookData(newBook: bookWithPage, nil)
                                }
                            }
                        } else {
                            // bookInfo 넘겨줘야함
                            var bookData = bookInfo
                            bookData.wish = true
                            saveBookData(newBook: bookData, nil)
                        }
                    }
                }
            }
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
                
                let decodedData = try decoder.decode(AladinJsonResponse.self, from: data)
                
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
    
    private func mappingToBookInfo(bookDataJsonResponse: AladinJsonResponseItem, page: Int) -> BookInfo {
        var bookInfo = BookInfo(id: String(bookDataJsonResponse.id),
                                author: bookDataJsonResponse.author,
                                bookDescription: bookDataJsonResponse.description,
                                coverImageUrl: bookDataJsonResponse.coverImage,
                                image: nil,
                                isbn: bookDataJsonResponse.isbn,
                                link: bookDataJsonResponse.link,
                                readingStatus: false,
                                repeatTime: 0,
                                page: page,
                                publisher: bookDataJsonResponse.publisher,
                                title: bookDataJsonResponse.title,
                                wish: false,
                                notes: [],
                                trackings: [],
                                readbooks: [])
        
        fetchImage(urlString: bookDataJsonResponse.coverImage) { imageData in
                if let imageData {
                    bookInfo.image = UIImage(data: imageData)
                } else {
                    print("Failed to fetch or convert image data.")
                }
        }
        
        return bookInfo
    }
    
    // 책을 저장한 적 없는 경우 아래 두개
    private func saveBookData(newBook: BookInfo, _ completion: ((BookInfo)->Void)?) {
        print("Save book to core data.")
        addBookInfoUseCase.execute(book: newBook) { bookInfo in
            guard let completion else { return }
            completion(bookInfo)
        }
    }
    
    private func setInitialReadingState(to newBook: BookInfo, _ completion: @escaping (BookInfo)->Void) {
        var resBook = newBook
        
        fetchImage(urlString: newBook.coverImageUrl) { imageData in
            DispatchQueue.main.async {
                if let imageData {
                    resBook.image = UIImage(data: imageData)
                } else {
                    print("Failed to fetch or convert image data.")
                }
                
                resBook.readingStatus = true
                let readingTracking = ReadingTracking(id: UUID(), readDate: Date(), readPage: 0)
                resBook.trackings.append(readingTracking)
                completion(resBook)
            }
        }
    }
    
    // 책을 읽은 적 있는 경우 아래 한개
    private func updateReadingStatus(newBook: BookInfo) {
        updateBookInfoUseCase.execute(book: newBook, of: nil) { _ in
            print("saved readingList to db")
            self.buttonText = "독서 진행중"
            self.tab = 0
        }
    }
    
    private func addToReadingList(newBook: BookInfo?) {
        if let newBook {
            setInitialReadingState(to: newBook) { initBook in
                var initialBook = initBook
                // 책을 읽은 적 있는 경우
                if bookInfo.page != 0 {
                    updateReadingStatus(newBook: initialBook)
                } else {
                    // new book에 page만 넣어주기
                    getBookDataWithPage(isbn: bookInfo.isbn!) { result in
                        if let bookWithPage = result {
                            initialBook.page = bookWithPage.page
                            updateReadingStatus(newBook: initialBook)
                        }
                    }
                }
            }
            
        } else {
            // 책을 읽은 적 없는 경우
            setInitialReadingState(to: bookInfo) { initBook in
                var initialBook = initBook
                getBookDataWithPage(isbn: bookInfo.isbn!) { result in
                    if let bookWithPage = result {
                        initialBook.page = bookWithPage.page
                        saveBookData(newBook: initialBook) { _ in
                            self.buttonText = "독서 진행중"
                            self.tab = 0
                            // 독서 진행중이면 클릭 못하게 작업하자
                        }
                    }
                }
            }
        }
    }
    
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
