//
//  ProgressView.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import SwiftUI

struct ProgressView: View {
    
    @State var progressValue:Float = 0
    @EnvironmentObject var model: DrinkModel
    
    var progressText: String {
        if self.progressValue < 0.3 {
            return "Keep hydrating"
        }
        else if self.progressValue < 0.6 {
            return "Keep up the good work!"
        } else if self.progressValue < 1 {
            return "Just a little bit more"
        } else {
            return "Great Job!"
        }
    }
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Color.blue
                    .opacity(0.1)
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Progress")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                            }
                            Spacer()
                            
                        }
                        .padding()
                        
                        Spacer()
                        
                        ProgressBar(progress: self.$progressValue)
                            .frame(width: 250, height: 250)
                            .padding(40)
                        
                        Text(progressText)
                            .font(.headline)
                            .bold()
                            .padding(.bottom)
                        
                        Divider()
                        
                        HStack {
                            Text("History")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                            
                            Spacer()
                        }
                        .padding([.leading, .top, .trailing])
                        
                        if !model.drinks.isEmpty {
                            VStack {
                                List {
                                    ForEach(model.drinks.reversed()) { drink in
                                        ListRow(name: drink.name, emoji: drink.emoji, amount: drink.amount, createdAt: drink.createdAt)
                                    }
                                    .onDelete { index in
                                        // get the item from the reversed list
                                        let item = model.drinks.reversed()[index.first ?? 0]
                                        // get the index of the item from the viewModel, and remove it
                                        if let ndx = model.drinks.firstIndex(of: item) {
                                            Task {
                                                let drinkId = model.drinks[ndx].id
                                                try await NetworkManager.shared.deleteDrink(drinkId: drinkId)
                                                model.drinks.remove(at: ndx)
                                                model.calculateProgress()
                                                self.progressValue = model.progress
                                            }
                                            
                                        }
                                    }
                                }
                                .frame(width: geo.size.width - 5, height: geo.size.height - 5 , alignment: .center)
                                .scrollContentBackground(.hidden)
                            }
                            Spacer()
                        }
                        else {
                            Text("No drinks have been added yet")
                                .font(.caption)
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
        }.onAppear{
            Task {
                try await model.loadData()
                self.progressValue = 0
                model.calculateProgress()
                self.progressValue = model.progress
            }
            
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView().environmentObject(DrinkModel())
    }
}
