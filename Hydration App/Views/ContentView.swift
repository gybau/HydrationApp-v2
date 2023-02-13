//
//  ContentView.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    
    
    var body: some View {
        
        
        
        
            TabView {
                
                ProgressView()
                    .tabItem {
                        VStack {
                            Image(systemName: "drop.fill")
                            Text("Hydration")
                        }
                    }
                    
                OptionsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "gear")
                            Text("Options")
                        }
                    }
                GraphView()
                    .tabItem {
                        VStack {
                            Image(systemName: "chart.bar")
                            Text("Chart")
                        }
                    }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DrinkModel())
    }
}
