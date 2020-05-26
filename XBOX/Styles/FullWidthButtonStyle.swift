//
//  FullWidthButtonStyle.swift
//  XBOX
//
//  Created by Anagh Sharma on 27/05/20.
//  Copyright © 2020 Anagh Sharma. All rights reserved.
//

import SwiftUI

struct FullWidthButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundColor(.white)
            .background(Color("accentColor"))
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }
}

struct RoundIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }
}

