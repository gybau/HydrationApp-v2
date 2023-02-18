//
//  Constants.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 25/11/2022.
//

import Foundation


struct Constants {
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    static let baseAuthUrl = "http://localhost:3000/auth"
    static let baseDrinkUrl = "http://localhost:3000/drinks"
}

enum NetworkError: Error {
    case badJson
    case badUrl
    case badRequest
    case badResponse
    case internalServerError
    case badJWTToken
}
