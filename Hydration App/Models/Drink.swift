//
//  Drink.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import Foundation


struct Drink: Hashable, Identifiable, Decodable, Encodable {
    
    var id = UUID()
    var name: String = ""
    var emoji: String = ""
    var amount: Float = 0
    var hydrationIndex: Float = 1
    
    static var sampleDrink = Drink(name: "Tea", emoji: "\u{1F375}", amount: 500, hydrationIndex: 1.1)
    static var sampleDrink2 = Drink(name: "Coffee", emoji: "\u{2615}", amount: 200, hydrationIndex: 0.85)
}
