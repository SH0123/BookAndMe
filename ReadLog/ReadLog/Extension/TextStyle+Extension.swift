//
//  TextStyle+Extension.swift
//  ReadLog
//
//  Created by sanghyo on 11/8/23.
//

import SwiftUI

struct Display: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)

            .font(.custom("omyu pretty", size: 29))

    }
}

struct Title: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)

            .font(.custom("omyu pretty", size: 24))

    }
}


struct BodyDefault: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("omyu pretty", size: 20))
            .foregroundStyle(color)
            .lineSpacing(15)
            .padding(.vertical, 7.5)
    }
}


struct Body1: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)

            .font(.custom("omyu pretty", size: 22))

    }
}


struct Body2: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)

            .font(.custom("omyu pretty", size: 20))

    }
}


struct Body3: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)

            .font(.custom("omyu pretty", size: 18))

    }
}


struct Mini: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)

            .font(.custom("omyu pretty", size: 16))

    }
}



extension View {
    func display(_ color: Color) -> some View {
        self.modifier(Display(color: color))
    }
    
    func title(_ color: Color) -> some View {
        self.modifier(Title(color: color))
    }
    
    func bodyDefault(_ color: Color) -> some View {
        self.modifier(BodyDefault(color: color))
    }
    
    func body1(_ color: Color) -> some View {
        self.modifier(Body1(color: color))
    }
    
    func body2(_ color: Color) -> some View {
        self.modifier(Body2(color: color))
    }
    
    func body3(_ color: Color) -> some View {
        self.modifier(Body3(color: color))
    }
    
    func mini(_ color: Color) -> some View {
        self.modifier(Mini(color: color))
    }
}
