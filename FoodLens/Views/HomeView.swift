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
    @EnvironmentObject var searchHistoryViewModel : SearchHistoryViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Greeting and Logout Button
                HStack {
                    if let email = Auth.auth().currentUser?.email {
                        Text("Hi \(email)!")
                            .font(.headline)
                    }
                    Spacer()
                    Button(action: logout) {
                        Text("Log Out")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .font(.callout)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                Spacer()
                
                VStack {
                    Text("FoodLens")
                        .font(.largeTitle)
                        Text("Your Go-To Grocery Shopping Tool")
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Info here
                VStack(spacing: 12) {
                    /* "Your go-to grocery shopping buddy etc.
                    // Simple Instructions, go to scanner tab and start scanning
                    // Find your search history and saved searches below!" */
                    VStack(spacing: 16) {
                        // App Description
                        Text("Get Quick Nutritional Information and Analysis By Scanning Product Barcode")
                            .font(.headline)
                            .multilineTextAlignment(.leading)

                        // Instructions
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
                                Image(systemName: "1.circle")
                                    .foregroundColor(.blue)
                                Text("Go to the scanner tab and start scanning barcodes on your groceries.")
                                    .font(.body)
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "2.circle")
                                    .foregroundColor(.blue)
                                Text("View your search history to revisit scanned items anytime.")
                                    .font(.body)
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "3.circle")
                                    .foregroundColor(.blue)
                                Text("Save items for quick access.")
                                    .font(.body)
                            }
                        }
                    }
                    .padding()
                }
                
                
                Divider()
                
                Spacer()

                // Navigation Buttons
                VStack(spacing: 20) {
                    NavigationLink(destination: SearchHistoryView()) {
                        Text("See Search History")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    NavigationLink(destination: SavedSearchView()) {
                        Text("See Saved Searches")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                Spacer()
            }
            .padding()
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
