//
//  sncfApp.swift
//  sncf
//
//  Created by Martin Voigt on 29.10.20.
//

import SwiftUI
import RealmSwift
import Combine


let app = RealmSwift.App(id: "application-0-kcogg")

/// State object for managing App flow.
class AppState: ObservableObject {
    /// Publisher that monitors log in state.
    var loginPublisher = PassthroughSubject<User, Error>()
    /// Publisher that monitors log out state.
    var logoutPublisher = PassthroughSubject<Void, Error>()
    /// Cancellables to be retained for any Future.
    var cancellables = Set<AnyCancellable>()
    @Published var shouldIndicateActivity = false
    @Published var tickets: RealmSwift.List<Ticket>?
    
    init() {
        // Create a private subject for the opened realm, so that we can open the realm later after login.
        let realmPublisher = PassthroughSubject<Realm, Error>()
        // Specify what to do when the realm opens, regardless of whether we're authenticated
        realmPublisher
            .sink(receiveCompletion: { result in
                // Check for failure.
                if case let .failure(error) = result {
                    print("Failed to log in and open realm: \(error.localizedDescription)")
                }
            }, receiveValue: { realm in
                // The realm has successfully opened.
                if realm.objects(Client.self).filter("userId == %@", app.currentUser!.id).count == 0 {
                    
                    // new clients have by default no reduction
                    let reduction = Reduction()
                    reduction.percentage = 0
                    reduction.reductionName = "Aucun"
                    
                    try! realm.write {
                        let newClient = Client()
                        // connect mongodb user and client model
                        newClient.userId = app.currentUser!.id
                        reduction.clients.append(newClient)
                        realm.add(newClient)
                        realm.add(reduction)
                    }
                }
                
                // tickets of active user
                self.tickets = realm.objects(Client.self).filter("userId == %@", app.currentUser!.id)[0].tickets
            })
            .store(in: &cancellables)
        
        // Monitor login state and open a realm on login.
        loginPublisher
            .receive(on: DispatchQueue.main) // Ensure we update UI elements on the main thread.
            .flatMap { user -> RealmPublishers.AsyncOpenPublisher in
                // Logged in, now open the realm.
                
                // We want to chain the login to the opening of the realm.
                // flatMap() takes a result and returns a different Publisher.
                // In this case, flatMap() takes the user result from the login
                // and returns the realm asyncOpen's result publisher for further
                // processing.
                
                // We use "SharedPartition" as the partition value so that all users of this app
                // can see the same data.
                let configuration = user.configuration(partitionValue: "SharedPartition")
                self.shouldIndicateActivity = true
                
                // Open the realm and return its publisher to continue the chain.
                return Realm.asyncOpen(configuration: configuration)
            }
            .receive(on: DispatchQueue.main) // Ensure we update UI elements on the main thread.
            .map { // For each realm result, whether successful or not, always stop indicating activity.
                self.shouldIndicateActivity = false // Stop indicating activity.
                return $0 // Forward the result as-is to the next stage.
            }
            .subscribe(realmPublisher) // Forward the opened realm to the handler we set up earlier.
            .store(in: &self.cancellables)
        
        // Monitor logout state and unset the items list on logout.
        logoutPublisher.receive(on: DispatchQueue.main).sink(receiveCompletion: { _ in }, receiveValue: { _ in
            self.tickets = nil
        }).store(in: &cancellables)
        
        // If we already have a current user from a previous app
        // session, announce it to the world.
        if let user = app.currentUser {
            loginPublisher.send(user)
        }
    }
}

@main
struct sncfApp: SwiftUI.App {
    
    @ObservedObject var state = AppState()
    
    var view: some View {
        ZStack {
            if let tickets = state.tickets {
                TabView {
                    TrainSearchView(tickets: tickets)
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Réservation")
                        }
                    UserTicketsView(tickets: tickets)
                        .tabItem {
                            Image(systemName: "qrcode")
                            Text("Mes voyages")
                        }
                    
                    ClientView(tickets: tickets)
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Mon compte")
                        }
                }
            }
            else {
                LoginView()
            }
            if state.shouldIndicateActivity {
                ActivityIndicator()
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            view.environmentObject(state)
        }
    }
}


// MARK: General View
/// Simple activity indicator to telegraph that the app is active in the background.
struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        return UIActivityIndicatorView(style: .large)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        (uiView as! UIActivityIndicatorView).startAnimating()
    }
}
