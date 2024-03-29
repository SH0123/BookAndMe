//
//  LicenseView.swift
//  ReadLog
//
//  Created by sanghyo on 12/11/23.
//

import SwiftUI

struct LicenseView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.backgroundColor
                .ignoresSafeArea()
            VStack {
                header
                    .padding(16)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("font - 오뮤 다예쁨체")
                            .body2(.black)
                        Group {
                            Text("스냅북에는 오뮤다이어리 x 보이저엑스에서 제작한 오뮤 다예쁨체가 적용되어 있습니다.")
                            Text("라이센스 전문보기 https://noonnu.cc/font_page/1136")
                        }.mini(.darkGray)
                            .tint(.darkGray)
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
    LicenseView()
}
