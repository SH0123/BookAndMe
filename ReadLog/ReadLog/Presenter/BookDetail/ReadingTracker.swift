//
//  ReadingTracker.swift
//  ReadLog
//
//  Created by 이만 on 2023/11/19.
//

import SwiftUI
import CoreData

//DailyProgress and ReadingTrackerModel definitions

// Model to represent daily reading progress
struct DailyProgress: Identifiable {
    let id = UUID()
    var day: String
    var pagesRead: Int
}

// ViewModel to handle the logic
class ReadingTrackerModel: ObservableObject {
    @Published var totalBookPages = 400 // total number of pages in book
    @Published var lastPageRead = 50 //Store the last page read
    @Published var dailyProgress: [DailyProgress] = [
        DailyProgress(day: "Mon", pagesRead: 0),
        DailyProgress(day: "Tue", pagesRead: 0),
        DailyProgress(day: "Wed", pagesRead: 0),
        DailyProgress(day: "Thu", pagesRead: 0),
        DailyProgress(day: "Fri", pagesRead: 0),
        DailyProgress(day: "Sat", pagesRead: 0),
        DailyProgress(day: "Sun", pagesRead: 0),
    ]
    
    /*private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
            self.context = PersistenceController.preview.container.viewContext
        }*/
    
    // Add current day's pages to daily progress
    func addDailyProgress(newPageRead: Int) {
        let day = getCurrentDay()
        if let index = dailyProgress.firstIndex(where: { $0.day == day }) {
            let pagesReadToday = newPageRead - lastPageRead
            if pagesReadToday > 0 {
                dailyProgress[index].pagesRead += pagesReadToday
        
               /* //For record in Core Data
                let newProgress = ReadingList (context: context)
                newProgress.readtime = Date()
                newProgress.readpage = Int32(pagesReadToday)
                
                do{
                    try context.save()
                }catch{
                    print("Failed to save context: \(error)")
                }*/
            }
            lastPageRead = newPageRead //Update last page read to the new input
        }
    }
    
    // Calculate total pages read so far
    var totalPagesRead: Int {
        dailyProgress.map { $0.pagesRead }.reduce(0, +)
    }
    
    // Calculate the progress percentage
    var progressPercentage: Double {
        Double(totalPagesRead) / Double(totalBookPages)
    }
    
    func getCurrentDay() -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E" // "E" date format symbol for the day of the week
            let currentDay = dateFormatter.string(from: Date())
            return currentDay
    }
}


struct ReadingTrackerView: View {
    
    //@Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var viewModel = ReadingTrackerModel(/*context: context*/)
    @State private var pagesReadInput: String = ""
    @FocusState private var isInputActive: Bool

    var body: some View {
        VStack {
            progressBar(value: viewModel.progressPercentage)
            Spacer(minLength: 20)
            HStack {
                ForEach(viewModel.dailyProgress) { progress in
                    Circle()
                        .fill(progress.pagesRead > 0 ? Color("lightBlue") : Color("gray"))
                        .frame(width: 45, height: 45)
                        .overlay(Text("\(progress.pagesRead)p"))
                        .body3(Color.primary)
                }
            }
            viewBookMemo(memos: Memo.sampleData)
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
            .onSubmit {
                if let newPageRead = Int(pagesReadInput), newPageRead > viewModel.lastPageRead {
                    viewModel.addDailyProgress(newPageRead: newPageRead)
                    pagesReadInput = "" // Clear the input field
                }
            }
            Spacer()
        }
        .background(Color("backgroundColor"))
    }
}

// function
private extension ReadingTrackerView {
    
}

// Component
private extension ReadingTrackerView {
    struct progressBar: View {
        var value: Double
        var thickness: CGFloat = 15

        var body: some View {
            GeometryReader { geometry in
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
}


#Preview{
        ReadingTrackerView()
    }
