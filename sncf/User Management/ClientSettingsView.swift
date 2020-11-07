//
//  ClientSettings.swift
//  sncf
//
//  Created by Martin Voigt on 06.11.20.
//

import SwiftUI
import RealmSwift

struct ClientSettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var tickets: RealmSwift.List<Ticket>

    @State private var givenName: String = ""
    @State private var name: String = ""
    @State private var adult = true
    @State private var percentageIndex: Int = 0
    
    var percentageOptions = [0, 5, 10, 15, 20]
    
    var body: some View {
            Form {
                Section(header: Text("Nom")) {
                    TextField("Nom", text: $name)
                    TextField("Prénom", text: $givenName)
                }
                Section(header: Text("Reduction")) {
                    Toggle(isOn: $adult) {
                        Text("Adulte")
                    }
                    Picker(selection: $percentageIndex, label: Text("Reduction (en %)")) {
                        ForEach(0 ..< percentageOptions.count) {
                            Text("\(self.percentageOptions[$0])")
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        guard let realm = tickets.realm else {
                            return
                        }
                        
                        let currentUser = tickets.realm?.objects(Client.self).filter("userId == %@", app.currentUser!.id)[0]
                        
                        try! realm.write {
                            currentUser!.adult = adult
                            currentUser!.givenName = givenName
                            currentUser!.name = name
                            realm.delete(currentUser!.reduction[0])
                            let newReduction = Reduction()
                            newReduction.percentage = percentageOptions[percentageIndex]
                            newReduction.clients.append(currentUser!)
                            realm.add(newReduction)
                        }
                        self.presentationMode.wrappedValue.dismiss()

                    }, label: {
                        Text("Appliquer")
                    })
                }
            }
    }
}
