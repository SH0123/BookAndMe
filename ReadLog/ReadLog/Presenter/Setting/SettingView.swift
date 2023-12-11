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
            header
            List {
                HStack {
                    Text("스냅북 버전")
                    Spacer()
                    Text("1.0.0")
                }
                NavigationLink {
                    LicenseView()
                } label: {
                    Text("오픈소스 라이센스")
                }
            }
            .title(.black)
            .listStyle(.plain)
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
