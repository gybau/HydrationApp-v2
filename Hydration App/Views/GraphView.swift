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
            Chart {
                BarMark(
                    x: .value("Day start", Date().startOfDay),
                    y: .value("Amount", 0))
                ForEach(model.drinks) { drink in
                    
//                    BarMark(
//                        xStart: .value("Date", Date().startOfDay),
//                        xEnd: .value("Date", Date().endOfDay),
//                        y: .value("Amount", drink.amount))
                    
                    BarMark(
                        x: .value("Date", drink.dateAdded),
                        y: .value("Amount", drink.amount))
                }
                BarMark(
                    x: .value("Day end", Date().endOfDay),
                    y: .value("Amount", 0))
            }
            .padding()
            
            Spacer()
            
        }
        
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView().environmentObject(DrinkModel())
    }
}
