//
//  RegistrationView.swift
//  sncf
//
//  Created by Martin Voigt on 06.11.20.
//

import SwiftUI
import RealmSwift


struct RegistrationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var givenName: String = ""
    @State private var adult: Bool = true
    @State private var birthDate = Date()
    
    @EnvironmentObject var state: AppState
    @State var error: Error?
    
    var body: some View {
        VStack {            
            VStack(alignment: .leading, spacing: 15) {
                TextField("E-mail", text: self.$email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20.0)
                
                SecureField("Mot de passe", text: self.$password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20.0)
                
                
                Button(action: {
                    app.emailPasswordAuth.registerUser(email: self.email.lowercased(), password: self.password, completion: { (error) in
                        DispatchQueue.main.sync {
                            guard error == nil else {
                                print("Signup failed: \(error!)")
                                return
                            }
                            print("Signup successful!")
                        }
                    })
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.yellow.opacity(0.2))
                            .cornerRadius(20.0)
                            .frame(height: 50, alignment: .center)
                        Text("S'inscrire")
                            .foregroundColor(.black)
                    }
                })
                .padding(.bottom, 20)
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text("Inscription"))
    }
}

