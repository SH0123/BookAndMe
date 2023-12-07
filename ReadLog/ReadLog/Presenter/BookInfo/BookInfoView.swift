//
//  BookInfoView.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI
import CoreData

struct BookInfoView: View {
    // core data
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(
//        sortDescriptors: [
//            NSSortDescriptor(keyPath: \BookInfo.id, ascending: false)
//        ],
//        animation: .default
//    )
//    private var dbBookData: FetchedResults<BookInfo>
    
    @State private var dbBookData:BookInfo?
    
    // view variables
    var bookInfo: BookInfoData
    
    @State var like = false
    @State var buttonText = "독서 시작"
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack {
            VStack {
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
                    
                    Text(bookInfo.description)
                        .bodyDefault(.black)
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
                    if dbBookData == nil {
                        Button {
                            print("start to read the book.")
                            
                            // if bookInfo object has page number, api call is not required.
                            if bookInfo.itemPage != 0 {
                                // save to core data
                                saveBookData(newBook: bookInfo)
                                addToReadingList(bookId: Int32(bookInfo.id))
                            } else {
                                // call isbn search api and take subinfo data
                                // save data to core data
                                let bookWithPage = getBookDataWithPage(isbn: bookInfo.isbn)
                                
                                if bookWithPage != nil {
                                    saveBookData(newBook: bookWithPage!)
                                    addToReadingList(bookId: Int32(bookWithPage!.id))
                                }
                                
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
                        NavigationLink(destination: BookDetailFull(dbBookData)) {
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
                        }
                    }
                }
                .padding(.top, 7)
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
            }
            .background(Color("backgroundColor"))
            .navigationTitle("책 정보")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            dbBookData = findBook(bookId: Int32(bookInfo.id))
            
            if dbBookData != nil {
                self.like = dbBookData!.wish
                
                if let readingList = dbBookData!.readingList {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                    
//                    self.buttonText = dateFormatter.string(from: readingList!.readtime)
                } else {
                    
                }
            }
        }
        .onDisappear {
            // save wishlist changes
            // if book data is not in db and added to wishlist, saves book data (wish = true)
            // if book data is in db, save changes
            
            if dbBookData == nil {
                if like {
                    if bookInfo.itemPage == 0 {
                        let bookWithPage = getBookDataWithPage(isbn: bookInfo.isbn)
                        
                        if bookWithPage != nil {
                            saveBookData(newBook: bookWithPage!)
                        }
                    } else {
                        saveBookData(newBook: bookInfo)
                    }
                    
                }
            } else {
                if like != dbBookData!.wish {
                    // save changes
                    updateBookWish(bookId: Int32(bookInfo.id))
                }
            }
        }
    }
    
    func getBookDataWithPage(isbn: String) -> BookInfoData? {
        let requestUrl = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=\(ApiKey.aladinKey)&itemIdType=ISBN13&ItemId=\(isbn)&output=js&Version=20131101"
        
        guard let url = URL(string: requestUrl) else {
            return nil
        }
        
        var book: BookInfoData?
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            
            
            do {
                let decoder = JSONDecoder()
                
                let decodedData = try decoder.decode(JsonResponse.self, from: data)
                
                DispatchQueue.main.async {
                    print(decodedData.item.count)
                    
                    let bookDataArray: [BookInfoData] = decodedData.item.map { bookData in
                        if let itemPage = bookData.subInfo?.itemPage {
                            let bookData = BookInfoData(
                                id: bookData.id,
                                isbn: bookData.isbn,
                                title: bookData.title,
                                author: bookData.author,
                                description: bookData.description,
                                coverImage: bookData.coverImage,
                                publisher: bookData.publisher,
                                price: bookData.price,
                                link: bookData.link,
                                itemPage: itemPage
                            )
                            return bookData
                        } else {
                            let bookData = BookInfoData(
                                id: bookData.id,
                                isbn: bookData.isbn,
                                title: bookData.title,
                                author: bookData.author,
                                description: bookData.description,
                                coverImage: bookData.coverImage,
                                publisher: bookData.publisher,
                                price: bookData.price,
                                link: bookData.link,
                                itemPage: 0
                            )
                            return bookData
                        }
                    }
                    
                    if !bookDataArray.isEmpty {
                        book = bookDataArray[0]
                    }
                    
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
        
        print("found book's page number: \(book!.itemPage)")
        return book
    }
    
    func findBook(bookId: Int32) -> BookInfo? {
        let fetchRequest: NSFetchRequest<BookInfo> = BookInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", bookId)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error fetching object by id: \(error)")
            return nil
        }
    }
    
    func saveBookData(newBook: BookInfoData) {
        let dbNewBook = BookInfo(context: viewContext)
        dbNewBook.id = Int32(newBook.id)
        dbNewBook.author = newBook.author
        dbNewBook.bookDescription = newBook.description
        dbNewBook.isbn = newBook.isbn
        dbNewBook.link = newBook.link
        dbNewBook.nthCycle = 0
        dbNewBook.page = Int32(newBook.itemPage)
        dbNewBook.publisher = newBook.publisher
        dbNewBook.title = newBook.title
        dbNewBook.wish = like
        dbNewBook.image = UIImage(data: URLImage(urlString: newBook.coverImage).data!)?.pngData()
        
        do {
            try viewContext.save()
            print("saved book to db")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addToReadingList(bookId: Int32) {
        guard let book = findBook(bookId: bookId) else {
            return
        }
        
        let newReading = ReadingList(context: viewContext)
        newReading.recent = true
        newReading.pinned = false
        newReading.readtime = Date()
        newReading.book = book
        
        book.readingList = [newReading]
        newReading.book = book
        
        do {
            try viewContext.save()
            print("saved readingList to db")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
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
}
