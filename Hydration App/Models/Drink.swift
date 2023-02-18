//
//  Drink.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import Foundation


struct Drink: Hashable, Identifiable, Codable {
    
    let id: Int
    let name: String
    let emoji: String
    let amount: Float
    let createdAt: Date
}
