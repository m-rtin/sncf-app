//
//  UserTicketsView.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import SwiftUI
import RealmSwift


struct UserTicketsView: View {
    @ObservedObject var tickets: RealmSwift.List<Ticket>
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(self.tickets.freeze(), id: \.self) { ticket in
                        TicketView(ticket: ticket)
                            .padding()
                    }
                    .onDelete(perform: delete)
                }
                .navigationBarTitle("Voyages")
            }
        }
        
    }
    
    // Delete tickets by swiping
    func delete(at offsets: IndexSet) {
        guard let realm = tickets.realm else {
            tickets.remove(at: offsets.first!)
            return
        }
        try! realm.write {
            realm.delete(tickets[offsets.first!])
        }
    }
}

