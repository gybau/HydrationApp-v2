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
    
    static let baseAuthUrl = "https://hydration-app-backend.vercel.app/auth"
    static let baseDrinkUrl = "https://hydration-app-backend.vercel.app/drinks"
}

enum NetworkError: Error {
    case badJson
    case badUrl
    case badRequest
    case badResponse
    case internalServerError
    case badJWTToken
}
