//
//  GraphView.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 28/11/2022.
//

import SwiftUI
import Charts

struct GraphView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Daily Chart")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            Text(Date.now.formatted(date: .long, time: .omitted))
                .font(.headline)
                
            Chart {
                BarMark(
                    x: .value("Day start", Date().startOfDay),
                    y: .value("Amount", 0))
                ForEach(model.drinks) { drink in
                    
                    LineMark(
                        x: .value("Date", drink.dateAdded),
                        y: .value("Amount", drink.amount))
                }
                BarMark(
                    x: .value("Day end", Date().endOfDay),
                    y: .value("Amount", 0))
            }
            .padding(.bottom, 100)
            .padding(.top, 100)
            
            
            Spacer()
            
        }
        .padding()
        
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView().environmentObject(DrinkModel())
    }
}
