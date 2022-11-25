//
//  DrinkModel.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import Foundation

class DrinkModel: ObservableObject {
    
    
    
    @Published var drinks: [Drink] = []
    @Published var progress: Float = 0
    @Published var target: Float = 2500
    
    init() {
        loadData()
        
        
        let todaysDate = Constants.dateFormatter.string(from: Date.now)
        for drink in drinks {
            if drink.dateAdded != todaysDate {
                
                drinks.remove(at: drinks.firstIndex(of: drink)!)
            }
        }
        calculateProgress()
        saveData()
        
        
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "drinks") {
            if let decoded = try? JSONDecoder().decode([Drink].self, from: data) {
                
                self.drinks = decoded
                
                if let data = UserDefaults.standard.data(forKey: "target") {
                    if let decoded = try? JSONDecoder().decode(Float.self, from: data) {
                        self.target = decoded
                        return
                    }
                }
                self.target = 0
            }
        }
        self.drinks = []
        self.target = 0
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(drinks) {
            UserDefaults.standard.set(encoded, forKey: "drinks")
        }
        if let encoded = try? JSONEncoder().encode(target) {
            UserDefaults.standard.set(encoded, forKey: "target")
        }
    }
    
    
    
    func calculateProgress() {
        
        var hydration: Float = 0
        
        for drink in drinks {
            let singleHydration = drink.amount * drink.hydrationIndex
            hydration += singleHydration
        }
        
        self.progress = hydration/target
    }
    
    
}
