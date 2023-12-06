//
//  NoteLabel.swift
//  ReadLog
//
//  Created by sanghyo on 11/13/23.
//

import SwiftUI

struct NoteLabel: View {
    @Binding var type: Note

    var body: some View {
        Text(type.noteText)
            .body2(.black)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//            .frame(width: 150, height: 40, alignment: .center)
            .background(type.noteColor)
    }
}

#Preview {
    VStack {
        NoteLabel(type: .constant(.impressive))
        NoteLabel(type: .constant(.myThink))
    }
}
