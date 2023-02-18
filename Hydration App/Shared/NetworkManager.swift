//
//  NetworkManager.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 17/02/2023.
//

import Foundation

struct SignupBodyParams: Codable {
    let name: String
    let email: String
    let password: String
}

struct LoginBodyParams: Codable {
    let email: String
    let password: String
}

struct UpdatebodyParams: Codable {
    let name: String?
    let target: Float?
}

struct AddDrinkParams: Codable {
    let name: String
    let emoji: String
    let amount: Int
}

class NetworkManager {
    static var shared = NetworkManager()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    var jwtToken: String?
    var user: User?
    
    private init() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    
    //MARK: - Auth
    func signup(name: String, email: String, password: String) async throws -> String {
        let jsonObject: SignupBodyParams = SignupBodyParams(name: name, email: email, password: password)
        guard let jsonData = try? encoder.encode(jsonObject) else { throw NetworkError.badJson }
        
        let urlString = Constants.baseAuthUrl + "/signup"
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 201 else { throw NetworkError.badResponse }
        
        let jwtToken = String(decoding: data, as: UTF8.self)
        
        return jwtToken
    }
    
    func signin(email: String, password: String) async throws -> String {
        let jsonObject: LoginBodyParams = LoginBodyParams(email: email, password: password)
        guard let jsonData = try? encoder.encode(jsonObject) else { throw NetworkError.badJson }
        
        let urlString = Constants.baseAuthUrl + "/signin"
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 201 else { throw NetworkError.badResponse }
        
        let jwtToken = String(decoding: data, as: UTF8.self)
        
        return jwtToken
    }
    
    func updateUser(name: String?, target: Float?) async throws {
        guard let jwtToken else { throw NetworkError.badJWTToken }
        
        let jsonObject: UpdatebodyParams = UpdatebodyParams(name: name, target: target)
        guard let jsonData = try? encoder.encode(jsonObject) else { throw NetworkError.badJson }
        
        let urlString = Constants.baseAuthUrl + "/update"
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 201 else { throw NetworkError.badResponse }
    }
    
    func getUser() async throws -> User {
        guard let jwtToken else { throw NetworkError.badJWTToken }
        
        let urlString = Constants.baseAuthUrl + "/me"
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.badResponse }
        
        let user = try decoder.decode(User.self, from: data)
        return user
    }
    
    
    
    //MARK: - Drinks
    func getDrinksForUser() async throws -> [Drink] {
        guard let jwtToken else { throw NetworkError.badJWTToken }
        
        let urlString = Constants.baseDrinkUrl
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.badResponse }
        
        
        let drinks = try decoder.decode([Drink].self, from: data)
        
        return drinks
    }
    
    func addDrink(name: String, emoji: String, amount: Int) async throws {
        guard let jwtToken else { throw NetworkError.badJWTToken }
        
        let jsonObject: AddDrinkParams = AddDrinkParams(name: name, emoji: emoji, amount: amount)
        guard let jsonData = try? encoder.encode(jsonObject) else { throw NetworkError.badJson }
        
        let urlString = Constants.baseDrinkUrl + "/add"
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 201 else { throw NetworkError.badResponse }
    }
    
    func deleteDrink(drinkId: Int) async throws {
        guard let jwtToken else { throw NetworkError.badJWTToken }
        
        let urlString = Constants.baseDrinkUrl + "/\(drinkId)"
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.badResponse }
    }
}
