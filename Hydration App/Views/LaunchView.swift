//
//  LaunchView.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 25/11/2022.
//

import SwiftUI
import HealthKit

struct LaunchView: View {
    
    @State var isAuthorized = false
    @State var email: String = "michal@gmail.com"
    @State var password: String = "hello"
    
    var body: some View {
        
        if isAuthorized {
            ContentView()
        }
        else {
            ZStack {
                Color.blue
                    .opacity(0.1)
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    VStack(spacing: 40) {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: Color.blue.opacity(0.5), radius: 5, x: -5, y: -5)
                        
                        Text("Ready to get hydrated?")
                            .font(.headline)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                        VStack {
                            HStack{
                                Image(systemName: "at")
                                TextField("Email", text: $email)
                            }
                            HStack{
                                Image(systemName: "lock")
                                SecureField("Password", text: $password)
                            }
                        }.padding(.horizontal, 40)
                        Button {
                            Task {
                                do {
                                    NetworkManager.shared.jwtToken = try await NetworkManager.shared.signin(email: email, password: password)
                                    guard let jwtToken = NetworkManager.shared.jwtToken else {
                                        print("Authorization error")
                                        return
                                    }
                                    NetworkManager.shared.user = try await NetworkManager.shared.getUser()
                                    guard let user = NetworkManager.shared.user else {
                                        print("User is nil")
                                        return
                                    }
                                    
                                    isAuthorized = true
                                } catch {
                                    print(error)
                                }
                            }
                            
                        } label: {
                            Text("Log In")
                                .font(.headline)
                        }
                        .buttonStyle(GradientButtonStyle())
                    }
                    Spacer()
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
