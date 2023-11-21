//
//  NoteLabel.swift
//  ReadLog
//
//  Created by sanghyo on 11/13/23.
//

import SwiftUI

struct NoteLabel: View {
    private var type: Note
    
    init(_ type: Note) {
        self.type = type
    }
    
    var body: some View {
        Text(type.rawValue)
            .body2(.black)
            .frame(width: 150, height: 40, alignment: .center)
            .background(type.noteColor)
            .padding(EdgeInsets(top: 3, leading: 6, bottom: 4, trailing: 6))
    }
}

#Preview {
    VStack {
        NoteLabel(.impressive)
        NoteLabel(.myThink)
    }
}
