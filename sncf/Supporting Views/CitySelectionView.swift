//
//  CitySelectionView.swift
//  sncf
//
//  Created by Martin Voigt on 29.10.20.
//

import SwiftUI
import RealmSwift

struct CitySelectionView: View {
    var cities: [String]
    
    @Binding var city: String
    
    var body: some View {
        
        Picker(selection: $city, label: Text("Please choose a city")) {
            ForEach(cities, id:\.self) { city in
                Text(city)
            }
        }
        .navigationBarTitle(Text("Quelle ville?"))
    }
}

