//
//  URLImage.swift
//  ReadLog
//
//  Created by 유석원 on 11/26/23.
//

import SwiftUI

struct URLImage: View {
    let urlString: String?
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .clipped()
                .padding(.horizontal, 15)
        } else {
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .clipped()
                .padding(.horizontal, 15)
                .onAppear {
                    fetchImageData()
                }
        }
    }
    
    private func fetchImageData() {
        guard let urlString = urlString else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
}
