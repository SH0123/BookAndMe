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
                    Spacer()
                        .frame(maxHeight: 20)
                    HStack {
                        Text("스냅북 버전")
                            .body1(.black)
                        Spacer()
                        Text("1.0.0")
                            .body1(.black)
                    }
                    Divider()
                    NavigationLink {
                        LicenseView()
                    } label: {
                        HStack {
                            Text("오픈소스 라이센스")
                                .body1(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    Divider()
                    Button(action: moveToGuidPage) {
                        HStack {
                            Text("iCloud 백업 가이드")
                                .body1(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    Divider()
                }
                .padding(.horizontal, 20)
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
    
    private func moveToGuidPage() {
        if let url = URL(string: "https://travelersh.notion.site/iCloud-053fcdab56a447ad9492fdb4d72d3814?pvs=4") {
            UIApplication.shared.open(url, options:[:])
        }
    }
}

#Preview {
    SettingView()
}
