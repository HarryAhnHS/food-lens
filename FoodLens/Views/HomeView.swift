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
    @EnvironmentObject var searchHistoryViewModel: SearchHistoryViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Greeting and Logout Button
                HStack {
                    if let email = Auth.auth().currentUser?.email {
                        Text("Hi \(email)!")
                            .font(.title)
                    } else {
                        Text("Welcome to FoodLens!")
                            .font(.title)
                    }
                    Spacer()
                    Button(action: logout) {
                        Text("Log Out")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()

                // Navigation Buttons
                VStack(spacing: 20) {
                    NavigationLink(destination: SearchHistoryView(searches: searchHistoryViewModel.searches)) {
                        Text("See Search History")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: SavedSearchView(searches: searchHistoryViewModel.searches)) {
                        Text("See Saved Searches")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .onAppear {
                searchHistoryViewModel.fetchSearches()
            }
        }
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
