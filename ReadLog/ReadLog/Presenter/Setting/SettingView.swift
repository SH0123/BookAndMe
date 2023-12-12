//
//  SettingView.swift
//  ReadLog
//
//  Created by sanghyo on 12/11/23.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color.backgroundColor
                    .ignoresSafeArea()
                VStack(spacing: 10) {
                    header
                    HStack {
                        Text("스냅북 버전")
                            .title(.black)
                        Spacer()
                        Text("1.0.0")
                    }
                    Divider()
                    NavigationLink {
                        LicenseView()
                    } label: {
                        HStack {
                            Text("오픈소스 라이센스")
                                .title(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    Divider()
                }
                .padding(.horizontal, 10)
                .background(Color.backgroundColor)
            }
            
        }
    }
    
    var header: some View {
        HStack {
            Spacer()
            Text("설정")
                .display(.black)
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
    }
}

#Preview {
    SettingView()
}
