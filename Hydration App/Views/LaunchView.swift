//
//  LaunchView.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 25/11/2022.
//

import SwiftUI
import HealthKit

struct LaunchView: View {
    
    private var healthStore: HealthStore?
    @State var isAuthorized: Bool
    
    init() {
        healthStore = HealthStore()
        self.isAuthorized = healthStore?.isHealthKitAuthorized() ?? false
    }
    
    var body: some View {
        
        if isAuthorized {
            ContentView()
        }
        else {
            ZStack {
                Color.blue
                    .opacity(0.1)
                    .ignoresSafeArea()
                VStack(spacing: 20){
                    VStack {
                        Image(systemName: "drop.triangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            
                        Text("Ready to get hydrated?")
                            .font(.headline)
                    }
                    
                    Button("Authorize HealthKit") {
                        if let healthStore = self.healthStore {
                            healthStore.requestAuthorization { success in
                                self.isAuthorized = healthStore.isHealthKitAuthorized()
                            }
                            
                        }
                    }
                }
                
                
            }
        }
        
        
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
