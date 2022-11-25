//
//  OptionsView.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import SwiftUI
import Combine

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
    @State var currentTarget: Float = 0
    
    @FocusState private var amountFieldIsFocused: Bool
    
    var body: some View {
        ZStack {
            Color.blue
                .opacity(0.1)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Add Drink")
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
                
                Divider()
                
                Text("Change daily goal")
                    .font(.largeTitle)
                    .bold()
                Text("Current: \(String(format: "%.f%", currentTarget))")
                    .font(.title3)
                    .bold()
                    
                
                Slider(value: $currentTarget, in: 0...10000, step: 50)
                    .onChange(of: currentTarget) { newValue in
                        DispatchQueue.main.async {
                            model.target = newValue
                            model.saveData()
                        }
                        
                    }
                Spacer()
            }
            .padding()
            
            
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
