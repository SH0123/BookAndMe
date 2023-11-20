//
//  NoteLabel.swift
//  ReadLog
//
//  Created by sanghyo on 11/13/23.
//

import Foundation
import SwiftUI

enum Note: String {
    case impressive = "인상 깊은 문장"
    case myThink = "나의 생각"
}

extension Note {
    var noteColor: Color {
        switch self {
        case .impressive:
            return .customPink
        case .myThink:
            return .skyBlue
        }
    }
}
