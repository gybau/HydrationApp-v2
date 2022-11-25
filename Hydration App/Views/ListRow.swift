//
//  ListRow.swift
//  Hydration App
//
//  Created by Michał Ganiebny on 23/11/2022.
//

import SwiftUI

struct ListRow: View {
    
    var name: String
    var emoji: String
    var amount: Float
    
    var body: some View {
        HStack {
            Text(emoji)
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(String(format: "%.f", amount) + "ml")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
                
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(name: "Water", emoji: "\u{1F4A7}", amount: 500)
    }
}
