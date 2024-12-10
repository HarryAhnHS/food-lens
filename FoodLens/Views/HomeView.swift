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

    var body: some View {
        VStack {
            Text("Welcome to FoodLens!")
                .font(.largeTitle)
                .padding()

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
            print("Error signing out: %@", signOutError)
        }
    }
}
