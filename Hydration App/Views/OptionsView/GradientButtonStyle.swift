//
//  LogToHKButton.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 27/11/2022.
//

import SwiftUI


struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing).cornerRadius(10))
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            
    }
}


