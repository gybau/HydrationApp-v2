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
    @Published var accessToken: String?
    
    init() {
        Task {
            try await loadData()
        }
        calculateProgress()
    }
    
    //    func loadData() {
    //        if let data = UserDefaults.standard.data(forKey: "drinks") {
    //            if let decoded = try? JSONDecoder().decode([Drink].self, from: data) {
    //
    //                self.drinks = decoded
    //
    //                if let data = UserDefaults.standard.data(forKey: "target") {
    //                    if let decoded = try? JSONDecoder().decode(Float.self, from: data) {
    //                        self.target = decoded
    //                        return
    //                    }
    //                }
    //                self.target = 1000
    //            }
    //        }
    //        self.drinks = []
    //        self.target = 1000
    //    }
    
    func loadTarget() {
        Task {
            let user = try await NetworkManager.shared.getUser()
            self.target = user.target
        }
    }
    
    func loadData() async throws {
        
            let user = try await NetworkManager.shared.getUser()
            let drinks = try await NetworkManager.shared.getDrinksForUser()
            DispatchQueue.main.async {
                self.target = user.target
                self.drinks = drinks
            }
        
        
    }
    
    func addDrink(name: String, emoji: String, amount: Int) {
        Task {
            try await NetworkManager.shared.addDrink(name: name, emoji: emoji, amount: amount)
            try await loadData()
        }
    }
    
    func calculateProgress() {
        Task {
            try await loadData()
        }
        var hydration: Float = 0
        
        for drink in drinks {
            let singleHydration = Float(drink.amount)
            hydration += singleHydration
        }
        self.progress = hydration/Float(target)
    }
}
