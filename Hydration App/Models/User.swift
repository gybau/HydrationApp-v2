//
//  User.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 17/02/2023.
//

import Foundation

struct User: Codable {
    var id: Int
    var name: String
    var email: String
    var target: Float
    var createdAt: Date
}
