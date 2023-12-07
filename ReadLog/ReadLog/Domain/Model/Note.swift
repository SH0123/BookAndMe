//
//  NoteLabel.swift
//  ReadLog
//
//  Created by sanghyo on 11/13/23.
//

import Foundation
import SwiftUI

enum Note: Int {
    case impressive, myThink
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
    
    var noteText: String {
        switch self {
        case .impressive:
            return "인상 깊은 문장"
        case .myThink:
            return "나의 생각"
        }
    }
}
