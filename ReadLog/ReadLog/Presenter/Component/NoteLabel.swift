//
//  NoteLabel.swift
//  ReadLog
//
//  Created by sanghyo on 11/13/23.
//

import SwiftUI

struct NoteLabel: View {
    @Binding var type: NoteType

    var body: some View {
        Text(type.noteText)
            .body2(.black)
            .frame(width: 130, height: 35)
            .background(type.noteColor)
    }
}

#Preview {
    VStack {
        NoteLabel(type: .constant(.impressive))
        NoteLabel(type: .constant(.myThink))
    }
}
