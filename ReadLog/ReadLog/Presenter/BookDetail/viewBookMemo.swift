//
//  viewBookMemo.swift
//  ReadLog UI
//
//  Created by 이만 on 2023/11/04.
//

import SwiftUI

struct viewBookMemo: View {
    @Environment(\.managedObjectContext) private var viewContext
    let memos: [Memo]
    let memoDateFormatter: DateFormatter = Date.yyyyMdFormatter
    
    var body: some View {
            ScrollView{
                VStack {
                    HStack{
                        VStack(alignment: .leading){
                            Text("독서 기록").title(Color.primary)
                            HStack {
                                Text("어떤 부분이 인상 깊었나요?").bodyDefault(Color.primary)
                                Spacer()
                                NavigationLink(destination:AddNoteView()){
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 24, height: 24)
                                }
                                .foregroundStyle(Color.primary)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
                    .background(Color("backgroundColor"))
                    LazyVStack {
                            ForEach(memos){memo in
                                Divider()
                                VStack(alignment: .leading, spacing:10) {
                                    HStack {
                                        Text(memoDateFormatter.string(from: memo.date))
                                            .bodyDefault(Color("gray"))
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        NoteLabel(type: .constant(.impressive))
                                    }
                                    Text(memo.content)
                                        .bodyDefault(Color.primary)
                                }
                                .padding(.vertical, 10)
                            }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color("backgroundColor"))
        }
    }

#Preview {
    viewBookMemo(memos: Memo.sampleData)
}
