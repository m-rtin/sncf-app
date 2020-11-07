//
//  ReservationView.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import SwiftUI
import MapKit
import RealmSwift

struct City: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct ReservationView: View {    
    @Environment(\.presentationMode) var presentationMode
    var tickets: RealmSwift.List<Ticket>
    var journey: Journey
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.7111, longitude: 1.7191),
        span: MKCoordinateSpan(latitudeDelta: 12, longitudeDelta: 8)
    )
    
    var body: some View {
        VStack {
            Text("Détails du voyage")
                .font(.title)
            TicketInformationView(journey: journey)
                .padding()
            
            Map(coordinateRegion: $region,
                annotationItems: [
                    City(coordinate: CLLocationCoordinate2D(latitude: journey.fromStation[0].latitude, longitude: journey.fromStation[0].longitude)),
                    City(coordinate: CLLocationCoordinate2D(latitude: journey.toStation[0].latitude, longitude: journey.toStation[0].longitude))
                ]
            ) { place in
                MapMarker(coordinate: place.coordinate, tint: .green)
            }
            
            Button(action: {
                createNewTicket(journey: journey, tickets: tickets)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.red.opacity(0.2))
                        .cornerRadius(5.0)
                        .frame(height: 50, alignment: .center)
                    Text("Valider cet aller à \(String(format: "%.2f€", calculateNewPrice(oldPrice: journey.price, tickets: tickets)))")
                        .foregroundColor(.black)
                }
            })
            
            Spacer()
        }
        .padding()
        
    }
}

