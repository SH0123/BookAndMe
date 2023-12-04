//
//  ReadingTracker.swift
//  ReadLog
//
//  Created by 이만 on 2023/11/19.
//

import SwiftUI

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
    @Published var dailyProgress: [DailyProgress] = [
        DailyProgress(day: "Mon", pagesRead: 0),
        DailyProgress(day: "Tue", pagesRead: 0),
        DailyProgress(day: "Wed", pagesRead: 0),
        DailyProgress(day: "Thu", pagesRead: 0),
        DailyProgress(day: "Fri", pagesRead: 0),
        DailyProgress(day: "Sat", pagesRead: 0),
        DailyProgress(day: "Sun", pagesRead: 0),
    ]
    
    // Add current day's pages to daily progress
    func addDailyProgress(pagesRead: Int) {
        let day = getCurrentDay()
        if let index = dailyProgress.firstIndex(where: { $0.day == day }) {
            dailyProgress[index].pagesRead += pagesRead // Increment the day's progress
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
    
    // Dummy function to get the current day
    func getCurrentDay() -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E" // "E" date format symbol for the day of the week
            let currentDay = dateFormatter.string(from: Date())
            return currentDay
    }
}

import SwiftUI

struct ReadingTrackerView: View {
    @StateObject private var viewModel = ReadingTrackerModel()
    @State private var pagesReadInput: String = ""
    @FocusState private var isInputActive: Bool 


    var body: some View {
        VStack {
            // 1. Progress Bar
            progressBar(value: viewModel.progressPercentage)
                .frame(width: 323, height: 20)
                .padding(.horizontal)

            // Spacer to adjust space between the progress bar and the circles
            Spacer(minLength: 20)

            // 2. Daily Progress Circles
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
                .frame(width:350)

            // 3. Text Field to Accept Integer Value
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
                if let pagesRead = Int(pagesReadInput), pagesRead > 0 {
                    viewModel.addDailyProgress(pagesRead: pagesRead)
                    pagesReadInput = "" // Clear the input field
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct progressBar: View {
    var value: Double
    var thickness: CGFloat = 15

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: thickness)
                    .opacity(0.3)
                    .foregroundColor(Color("gray"))

                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: thickness)
                    .foregroundColor(Color("lightBlue"))
                    .animation(.linear, value: value)
            }
            .clipShape(RoundedRectangle(cornerRadius: 45))
        }
    }
}

#Preview{
        ReadingTrackerView()
    }




