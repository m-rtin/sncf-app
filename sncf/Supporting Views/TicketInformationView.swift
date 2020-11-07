//
//  TicketInformationView.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import SwiftUI

struct TicketInformationView: View {
    var journey: Journey
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(alignment: .leading) {
                Text(getHourAndMinute(date: journey.fromDate))
                Text(getDateString(date: journey.fromDate))
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                Text(getHourAndMinute(date: journey.toDate))
                Text(getDateString(date: journey.toDate))
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            VStack(alignment: .leading) {
                Text(journey.fromStation[0].stationName)
                    .fontWeight(.bold)
                Text(journey.toStation[0].stationName)
                Text(journey.train[0].trainName)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("À partir de")
                Text(String(format: "%.2f€", journey.price))
                Text("\(getNumberOfDisponiblePlaces(journey: journey)) pl disp.")
                    .font(.footnote)
                    .foregroundColor(getNumberOfDisponiblePlaces(journey: journey) > 0 ? Color.green : Color.red)
                Image(systemName: trainHasWifi(train: journey.train[0]) ? "wifi": "")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
        }
    }
}
