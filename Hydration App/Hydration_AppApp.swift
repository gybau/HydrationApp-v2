//
//  Hydration_AppApp.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import SwiftUI

@main
struct Hydration_AppApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView().environmentObject(DrinkModel())
        }
    }
}
