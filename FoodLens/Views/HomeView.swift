//
//  HomeView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var userEmail: String? = Auth.auth().currentUser?.email

    var body: some View {
        VStack {
            if let email = userEmail {
                Text("Hi \(email)!")
                    .font(.title)
                    .padding()
            } else {
                Text("Hi there!")
                    .font(.title)
                    .padding()
            }

            Button(action: logout) {
                Text("Log Out")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            appState.isLoggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
