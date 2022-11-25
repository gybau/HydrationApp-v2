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
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
}
