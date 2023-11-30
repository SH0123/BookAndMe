//
//  SearchBar.swift
//  ReadLog
//
//  Created by 유석원 on 11/20/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
//    var fetchData: (String) -> Void
    @StateObject var viewModel: PaginationViewModel
    
    var body: some View {
        HStack {
            HStack {
//                Image(systemName: "magnifyingglass")
                
                TextField("책 제목, 작가, 출판사", text: $text, onCommit: {
                    
                    if !text.isEmpty {
                        viewModel.clear()
                        viewModel.setKeyword(keyword: text)
                        viewModel.searchData()
                    }
                    
                    
                    // hide keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                })
                .foregroundColor(.primary)
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
    }
}

//#Preview {
//
//}
