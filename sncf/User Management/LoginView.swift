//
//  LoginView.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var currentUser = ""
    
    @EnvironmentObject var state: AppState
    @State var error: Error?
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 15) {
                    TextField("E-mail", text: self.$email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20.0)
                    
                    SecureField("Mot de passe", text: self.$password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20.0)
                        .padding(.bottom, 10)
                    
                    
                    if let error = error {
                        Text("Error: \(error.localizedDescription)")
                            .padding(.bottom, 10)
                    }
                    
                    Button("S'identifier") {
                        state.shouldIndicateActivity = true
                        
                        app.login(credentials: Credentials.emailPassword(email: self.email.lowercased(), password: self.password)).receive(on: DispatchQueue.main).sink(receiveCompletion: {
                            state.shouldIndicateActivity = false
                            switch ($0) {
                            case .finished:
                                break
                            case .failure(let error):
                                self.error = error
                            }
                        }, receiveValue: {
                            self.error = nil
                            state.loginPublisher.send($0)
                        }).store(in: &state.cancellables)
                    }.disabled(state.shouldIndicateActivity)
                    .padding(.bottom, 20)
                    
                }
                
                Text("Vous n'avez pas encore de compte ?")
                
                NavigationLink(destination: RegistrationView(), label: {
                    Text("S'inscrire")
                })
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Connexion")
            
        }
        
    }
}

