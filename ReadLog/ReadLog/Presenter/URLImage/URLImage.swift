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
            Image("")
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
        // coversum, cover200, cover500...
        guard let urlString = urlString?.replacingOccurrences(of: "coversum", with: "cover200") else {
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
