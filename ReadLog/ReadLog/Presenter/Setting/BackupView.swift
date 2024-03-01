//
//  BackupView.swift
//  ReadLog
//
//  Created by sanghyo on 3/1/24.
//

import SwiftUI

struct BackupView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.backgroundColor
                .ignoresSafeArea()
            VStack {
                header
                    .padding(16)
                    VStack(alignment: .leading, spacing: 10) {
                        
                    }
            }
            .toolbar(.hidden)
        }
    }
    
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.primary)
            }
            Spacer()
        }
        .tint(.black)
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
    }
}

#Preview {
    BackupView()
}
