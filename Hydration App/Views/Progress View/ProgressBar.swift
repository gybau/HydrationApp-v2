//
//  ProgressBar.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import SwiftUI

struct ProgressBar: View {
    
    @Binding var progress: Float
    @EnvironmentObject var model:DrinkModel
    
    //@Namespace var namespace
    
    var body: some View {
        ZStack {
                    Circle()
                        .stroke(lineWidth: 40)
                        .opacity(0.4)
                        .foregroundColor(.blue)
                        .shadow(color: Color.blue, radius: 5)

                    Circle()
                        .trim(from:0.0, to: CGFloat(min(self.progress, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.blue.opacity(0.8))
                        .opacity(0.8)
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.linear(duration: 1))
            VStack {
                Text(String(format: "%.0f %%", min(self.progress, 1.0)*100))
                    .font(.largeTitle)
                .bold()
                Text("of \(String(format: "%.f%", model.target))ml")
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: Binding.constant(0.5)).environmentObject(DrinkModel())
    }
}
