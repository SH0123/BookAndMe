//
//  viewBookMemo.swift
//  ReadLog UI
//
//  Created by 이만 on 2023/11/04.
//

import SwiftUI

struct Memo: Identifiable {
    let id: Int
    let date: Date
    let label: String
    let content: String
}

//sample data
extension Memo{
    static var sampleData: [Memo] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return [
            Memo(id: 1, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 2, date:dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할."),
            Memo(id: 3, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 4, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 5, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 6, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다."),
            Memo(id: 7, date: dateFormatter.date(from: "2023년 11월 1일")!, label: "나의 생각",
                 content: "강조할 공유하지 않겠다는 물이 있다. 셀카를 그 사람에게 물러난 점들을 그의 입장에서 충분히 타당하나 내가게는 개인적으로 타격이 없는 것들이 대부분이다.")
        ]
    }
}

   //kena repair date viewing

struct viewBookMemo: View {
    let memos: [Memo]
    
    static let memoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var body: some View {
            ScrollView{
                VStack {
                    HStack{
                        VStack(alignment: .leading){
                            Text("독서 기록").title(Color.primary)
                            Text("어떤 부분이 인상 깊었나요?").bodyDefault(Color.primary)
                        }
                        Spacer()
                        NavigationLink(destination:AddNoteView()){
                            Image(systemName: "plus.app")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 24, height: 24)
                        }
                        .foregroundStyle(Color.primary)
                        
                    }
                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5))
                    .background(Color("backgroundColor"))
                    Divider()
                    
                    
                    LazyVStack {
                        Section{
                            ForEach(memos){memo in
                                
                                VStack(alignment: .leading, spacing:8){
                                    HStack {
                                        Text("\(memo.date, formatter: Self.memoDateFormatter)")
                                            .bodyDefault(Color("gray"))
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        //LabelView(text: memo.label)
                                        NoteLabel(.impressive)
                                    }
                                    Text(memo.content)
                                        .bodyDefault(Color.primary)
                                        .lineSpacing(6)
                                    
                                }//where vstack ends
                                
                                .padding(EdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 5))
                                .listRowInsets(EdgeInsets())
                                
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color("backgroundColor"))
        }
        
    
    }


struct LabelView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .body3(Color.primary)
            .foregroundStyle(.black)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color("skyBlue"))
    }
}


#Preview {
    viewBookMemo(memos: Memo.sampleData)
}
