//
//  FoodLensApp.swift
//  FoodLens
//
//  Created by Harry Ahn on 9/12/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import Foundation
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
            print("isLoggedIn updated to: \(isLoggedIn)")
            // store logged
        }
    }

    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn") // initialize to false, unless already in defaults
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
    }
}


@main
struct FoodLensApp: App {
    @StateObject var appState = AppState()
    @StateObject private var searchHistoryViewModel = SearchHistoryViewModel();
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                MainTabView()
                    .environmentObject(appState)
                    .environmentObject(searchHistoryViewModel)
                    .onAppear {
                        searchHistoryViewModel.fetchSearches()
                        // Fetch searches for logged in user to update viewModel
                    }
            } else {
                LoginView()
                    .environmentObject(appState)
            }
        }
    }
}
