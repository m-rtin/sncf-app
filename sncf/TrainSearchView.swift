//
//  TrainSearchView.swift
//  sncf
//
//  Created by Martin Voigt on 29.10.20.
//

import SwiftUI
import RealmSwift

struct TrainSearchView: View {
    @ObservedObject var tickets: RealmSwift.List<Ticket>
    
    @State private var fromCity = ""
    @State private var toCity = ""
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                Text("Bonjour")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Text(getGivenNameOfClient(tickets: tickets))
                    .font(.title)
                Text("où désirez-vous aller ?")
                    .font(.title2)
                
                NavigationLink(destination: CitySelectionView(cities: getFromCities(tickets: tickets),
                                                              city: $fromCity),
                               label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color.gray.opacity(0.2))
                                        .cornerRadius(5.0)
                                        .frame(height: 50, alignment: .center)
                                    HStack(spacing: 20) {
                                        Text("Arrivée")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(fromCity == "" ? "Arrivée (ville)" : fromCity)
                                            .foregroundColor(fromCity == "" ? Color.gray : Color.black)
                                    }
                                    .padding(.horizontal, 20)
                                }
                               })
                
                NavigationLink(destination: CitySelectionView(cities: getToCities(tickets: tickets),
                                                              city: $toCity),
                               label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color.gray.opacity(0.2))
                                        .cornerRadius(5.0)
                                        .frame(height: 50, alignment: .center)
                                    HStack(spacing: 20) {
                                        Text("Départ")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text(toCity == "" ? "Départ (ville)" : toCity)
                                            .foregroundColor(toCity == "" ? Color.gray : Color.black)
                                    }
                                    .padding(.horizontal, 20)
                                }
                               })
                
                NavigationLink(destination: AvailableTrainsView(tickets: tickets, journies: getAvailableJournies(tickets: tickets, fromCity: fromCity, toCity: toCity))) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.green.opacity(0.2))
                            .cornerRadius(5.0)
                            .frame(height: 50, alignment: .center)
                        Text("Rechercher")
                            .foregroundColor(.black)
                    }
                }.padding(.top, 10)
                
                Spacer()
                
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
        }
    }
    
    
}

