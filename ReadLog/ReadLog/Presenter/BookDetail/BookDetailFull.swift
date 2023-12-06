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
    @FetchRequest (
        sortDescriptors: [],
        predicate: NSPredicate(format: "isbn == %@", "newBook3")
    ) private var value: FetchedResults<BookInfo>
    let isbn: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    displayBook(isbn: self.isbn)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 40, trailing: 0))
                    ReadingTrackerView()
                }
            }
            .padding()
            .background(Color("backgroundColor"))
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action:{
                        self.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.primary)
                    }
                }
                
                //TODO: When the button is pressed, add book into readList
                ToolbarItem(placement: .topBarTrailing){
                    Button("완독"){
                    }
                    .body1(Color.primary)
                }
            }
        }
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
    
    func fetchReadingData(isbn: String) -> [ReadingList]{
        let today: Date = Date()
        let monTodayDiff: Int = (6 + Calendar.current.dateComponents([.weekday], from: today).weekday!) % 7
        let monday: Date = Calendar.current.date(byAdding:.day, value: -1*monTodayDiff, to: today)!
        
        let fetchRequest: NSFetchRequest<ReadingList>
        
        fetchRequest = ReadingList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%@ LIKE %K && %K >= %@ ",isbn, #keyPath(ReadingList.book.isbn), #keyPath(ReadingList.readtime), monday as NSDate)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func fetchLastWeekReadingData(isbn: String) -> ReadingList {
        let today: Date = Date()
        let monTodayDiff: Int = (6 + Calendar.current.dateComponents([.weekday], from: today).weekday!) % 7
        let monday: Date = Calendar.current.date(byAdding:.day, value: -1*monTodayDiff, to: today)!
        
        let fetchRequest: NSFetchRequest<ReadingList>
        
        fetchRequest = ReadingList.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ReadingList.readtime, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "%@ LIKE %K && %K < %@ ",isbn, #keyPath(ReadingList.book.isbn), #keyPath(ReadingList.readtime), monday as NSDate)
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return objects.first!
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Error\(nsError)")
        }
    }
    
    func fetchAllBookNotes(isbn: String) -> [ReadLog]{
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
}

// Component
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
                            .frame(width: 96, height: 140)
                            .background(Color.white)
                    }else{
                        Image(systemName: "book")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 140)
                            .background(Color.white)
                    }
                    VStack(alignment: .leading){
                        Text(book.title ?? "Unknown Title")
                            .title(Color.primary)
                            .padding(.bottom,10)
                        Text(book.author ?? "Unknown Author")
                            .body2(Color.primary)
                            .padding(.bottom,2)
                        Text(book.publisher ?? "Unknown Publisher")
                            .body2(Color.primary)
                            .padding(.bottom,2)
                    }
                    .padding(.leading,10)
                }
                .frame(width: 323.0, height: 200)
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

#Preview {
    BookDetailFull(isbn: "newBook1")
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
