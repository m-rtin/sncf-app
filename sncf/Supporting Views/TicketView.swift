//
//  TicketView.swift
//  sncf
//
//  Created by Martin Voigt on 31.10.20.
//

import SwiftUI
import RealmSwift

struct TicketView: View {
    var ticket: Ticket
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(ticket.journey[0].fromStation[0].stationName)
                        .fontWeight(.bold)
                    Text(ticket.journey[0].toStation[0].stationName)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Voiture: \(ticket.placesToSit[0].wagon[0].wagonNumber)")
                        Image(systemName: ticket.placesToSit[0].windowPlace ? "wifi": "wifi.slash")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    }
                    HStack {
                        Text("Place assise: \(ticket.placesToSit[0].placeNumber)")
                        Image(systemName: ticket.placesToSit[0].wagon[0].hasWifi ? "macwindow": "ellipsis")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    }
                }
            }
            .padding(.bottom, 10)
            
            Text(ticket.journey[0].train[0].trainName)
            Text(String(format: "Prix ​​d'origine: %.2f€", ticket.journey[0].price))
            Text(String(format: "Prix ​​avec réduction: %.2f€", ticket.price))
                .padding(.bottom, 10)
            
            HStack {
                VStack {
                    Text("Départ")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Text(getDateString(date: ticket.journey[0].fromDate))
                    Text(getHourAndMinute(date: ticket.journey[0].fromDate))
                        .fontWeight(.bold)
                }
                Spacer()
                VStack {
                    Text("Arrivée")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Text(getDateString(date: ticket.journey[0].toDate))
                    Text(getHourAndMinute(date: ticket.journey[0].toDate))
                        .fontWeight(.bold)
                }
            }
        }
    }
}


struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
