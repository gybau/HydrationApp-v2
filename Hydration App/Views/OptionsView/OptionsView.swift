//
//  OptionsView.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import SwiftUI
import Combine
import UIKit

struct OptionsView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    let drinkNames = ["Water", "Tea", "Coffee", "Coke"]
    let emojis = [Emojis.Water, Emojis.Tea, Emojis.Coffee, Emojis.Coke]
    
    enum Emojis: String {
        case Water = "\u{1F4A7}"
        case Tea = "\u{1F375}"
        case Coffee = "\u{2615}"
        case Coke = "\u{1F964}"
    }
    
    
    
    
    
    @State var selectedDrink = "Water"
    @State var selectedEmoji:String = Emojis.Water.rawValue
    @State var drinkAmount: String = ""
    @State var currentTarget: Float = 1000
    
    @FocusState private var amountFieldIsFocused: Bool
    
    var body: some View {
        
        
        
        ZStack {
            Color.blue
                .opacity(0.1)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Add drink")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                    
                    
                    
                    
                    // MARK: Drink type picker
                    Picker("Drink Picker", selection: $selectedDrink) {
                        ForEach(drinkNames, id: \.self) { drink in
                            Text(drink).tag(drink)
                            
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Picker("Emoji Picker", selection: $selectedEmoji) {
                        ForEach(emojis, id: \.self) { emoji in
                            Text(emoji.rawValue).tag(emoji.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // MARK: Amount field
                    HStack {
                        Button {
                            amountFieldIsFocused = false
                            
                            drinkAmount = ""
                            
                        } label: {
                            Image(systemName: "xmark.circle")
                                .tint(.black)
                        }
                        
                        
                        TextField("Amount (ml)", text: $drinkAmount)
                            .keyboardType(.numberPad)
                            .focused($amountFieldIsFocused)
                            .onReceive(Just(drinkAmount)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.drinkAmount = filtered
                                }
                            }
                        
                        Button {
                            amountFieldIsFocused = false
                            
                            guard let amountAsInt = Int(drinkAmount) else { return }
                            
                            model.addDrink(name: selectedDrink, emoji: selectedEmoji, amount: amountAsInt)
                            self.drinkAmount = ""
                            
                            
                            
                        } label: {
                            Text("Add")
                        }
                        .disabled(drinkAmount == "")
                    }
                    Group {
                        
                        
                        Divider()
                        
                        Text("Daily goal")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                        HStack {
                            Text("Current: \(String(format: "%.f%", currentTarget))ml")
                                .font(.caption)
                                .bold()
                            Spacer()
                            Text("Slide to change")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        
                        
                        
                        Slider(value: $currentTarget, in: 0...10000, step: 50)
                            .onChange(of: currentTarget) { newValue in
                                DispatchQueue.main.async {
                                    model.target = newValue
                                }
                                Task {
                                    try await NetworkManager.shared.updateUser(name: nil, target: newValue)
                                }
                            }
                    }
                    Group {
                        
                        Divider()
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            
        }
        .onAppear {
            self.currentTarget = model.target
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(DrinkModel())
    }
}
