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
    
    private var healthstore: HealthStore?
    
    
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
    
    init() {
        self.healthstore = HealthStore()
    }
    
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
                            
                            
                            var newDrink = Drink()
                            newDrink.name = selectedDrink
                            newDrink.emoji = selectedEmoji
                            newDrink.amount = Float(drinkAmount) ?? 0
                            
                            // Add todays date
                            //                        let dateFormatter = DateFormatter()
                            //                        dateFormatter.dateStyle = .long
                            //                        dateFormatter.timeStyle = .short
                            
                            newDrink.dateAdded = Date()
                            
                            switch newDrink.name {
                            case "Water":
                                newDrink.hydrationIndex = 1
                            case "Tea":
                                newDrink.hydrationIndex = 1.1
                            case "Coffee":
                                newDrink.hydrationIndex = 0.85
                            case "Coke":
                                newDrink.hydrationIndex = 1.15
                            default:
                                newDrink.hydrationIndex = 1
                                
                            }
                            
                            DispatchQueue.main.async {
                                model.drinks.append(newDrink)
                                model.saveData()
                                
                            }
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
                                    model.saveData()
                                }
                                
                            }
                    }
                    Group {
                        
                        Divider()
                        Spacer()
                        
                        HStack {
                            Spacer()
                            VStack {
                                Button {
                                    if let healthstore = self.healthstore {
                                        for drink in model.drinks {
                                            healthstore.storeWater(amount: Double(drink.amount)) { success in
                                                DispatchQueue.main.async {
                                                    model.drinks.remove(at: model.drinks.firstIndex(of: drink)!)
                                                    model.saveData()
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    Text("Log to health")
                                        .font(.headline)
                                    
                                }
                                .buttonStyle(GradientButtonStyle())
                                
                                Text("Note: Logging to health clears all local data")
                                    .font(.headline)
                            }
                            
                            Spacer()
                        }
                        
                        
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
