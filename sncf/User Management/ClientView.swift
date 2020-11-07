//
//  ClientView.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import SwiftUI
import RealmSwift

struct ClientView: View {
    @EnvironmentObject var state: AppState
    @ObservedObject var tickets: RealmSwift.List<Ticket>
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Nom: \(getGivenNameOfClient(tickets: tickets))")
                        Text("Prénom: \(getNameOfClient(tickets: tickets))")
                        Text(isClientAdult(tickets: tickets) ? "Adulte: Oui": "Adulte: Non")
                            .padding(.bottom, 10)
                        
                    }
                    Spacer()
                    VStack {
                        Text("Reduction")
                        Text("\(reductionPercentageOfClient(tickets: tickets))%")
                            .font(.title)
                    }
                }
                .padding()
                
                NavigationLink(destination: ClientSettingsView(tickets: tickets), label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.purple.opacity(0.2))
                            .cornerRadius(5.0)
                            .frame(height: 50, alignment: .center)
                        Text("Remise à zéro")
                            .foregroundColor(.black)
                    }
                })
                
                Spacer()
                
                Button("Deconnexion") {
                    state.shouldIndicateActivity = true
                    app.currentUser?.logOut().receive(on: DispatchQueue.main).sink(receiveCompletion: { _ in }, receiveValue: {
                        state.shouldIndicateActivity = false
                        state.logoutPublisher.send($0)
                    }).store(in: &state.cancellables)
                }.disabled(state.shouldIndicateActivity)
                .padding(.bottom, 20)
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .navigationBarTitle(Text("Données personnelles"))
        }
    }
}
