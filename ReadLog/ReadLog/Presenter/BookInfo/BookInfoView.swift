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
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \BookInfo.id, ascending: false)
        ],
        animation: .default
    )
    private var dbBookData: FetchedResults<BookInfo>
    
    // view variables
    var bookInfo: BookInfoData
    
    @State var bookWithPage: BookInfoData?
    @State var like = false
    @State var buttonText = "독서 시작"
    
    @Environment(\.openURL) var openURL
    
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
                        if buttonText == "독서 시작" {
                            Button {
                                print("start to read the book.")
                                dbBookData.nsPredicate = NSPredicate(format: "id == %d", Int32(bookInfo.id))
                                if dbBookData.isEmpty {
                                    // if bookInfo object has page number, api call is not required.
                                    if bookInfo.itemPage != 0 {
                                        // save to core data
                                        saveBookData(newBook: bookInfo)
                                        addToReadingList(bookId: Int32(bookInfo.id))
                                    } else {
                                        // call isbn search api and take subinfo data
                                        // save data to core data
                                        getBookDataWithPage(isbn: bookInfo.isbn) { result in
                                            if let bookWithPage = result {
                                                saveBookData(newBook: bookWithPage)
                                                addToReadingList(bookId: Int32(bookWithPage.id))
                                            }
                                        }
                                    }
                                } else {
                                    addToReadingList(bookId: Int32(bookInfo.id))
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
                            
                            NavigationLink(destination: BookDetailFull(dbBookData.first, isRead: false).navigationBarBackButtonHidden(true)) {
                                
                                
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
            dbBookData.nsPredicate = NSPredicate(format: "id == %d", Int32(bookInfo.id))
            if !dbBookData.isEmpty {
                self.like = dbBookData.first!.wish
                
                if let readingList = dbBookData.first!.readingList as? Set<ReadingList> {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                    
                    let recent = readingList.filter { $0.recent == true }
                    
                    if !recent.isEmpty {
                        self.buttonText = dateFormatter.string(from: recent.first!.readtime!)
                    }
                    
                }
            }
        }
        .onDisappear {
            // save wishlist changes
            // if book data is not in db and added to wishlist, saves book data (wish = true)
            // if book data is in db, save changes
            dbBookData.nsPredicate = NSPredicate(format: "id == %d", Int32(bookInfo.id))
            if dbBookData.isEmpty {
                if like {
                    if bookInfo.itemPage == 0 {
                        getBookDataWithPage(isbn: bookInfo.isbn) { result in
                            if let bookWithPage = result {
                                saveBookData(newBook: bookWithPage)
                            }
                        }
                    } else {
                        saveBookData(newBook: bookInfo)
                    }
                }
            } else {
                if like != dbBookData.first!.wish {
                    updateBookWish(bookId: Int32(bookInfo.id))
                }
            }
        }
    }
    
    func getBookDataWithPage(isbn: String, completion: @escaping (BookInfoData?) -> Void) {
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
                                link: bookData.link,
                                itemPage: itemPage,
                                dbImage: nil,
                                dbWish: false,
                                dbNthCycle: 0
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
                                link: bookData.link,
                                itemPage: 0,
                                dbImage: nil,
                                dbWish: false,
                                dbNthCycle: 0
                            )
                            return bookData
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
        print("Save book to core data.")
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
        
        fetchImage(urlString: newBook.coverImage) { imageData in
            DispatchQueue.main.async {
                if let imageData = imageData {
                    dbNewBook.image = imageData
                    
                    viewContext.perform {
                        do {
                            try viewContext.save()
                            print("Book data saved with image.")
                        } catch {
                            let nsError = error as NSError
                            fatalError("Error saving book data: \(nsError), \(nsError.userInfo)")
                        }
                    }
                } else {
                    print("Failed to fetch or convert image data.")
                }
            }
            
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            self.buttonText = dateFormatter.string(from: newReading.readtime!)
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
    
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
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
