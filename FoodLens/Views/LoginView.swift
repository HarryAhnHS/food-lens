//
//  LoginView.swift
//  FoodLens
//
//  Created by Harry Ahn on 9/12/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to FoodLens")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Email Field
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Login Button
                Button(action: {
                    loginWithEmailPassword()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                // Sign Up Button
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }

                Divider()

                // Google Sign-In Button
                Button(action: {
                    loginWithGoogle()
                }) {
                    HStack {
                        Image(systemName: "globe")
                        Text("Sign in with Google")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                }
            }
            .padding()
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Email/Password Login
    func loginWithEmailPassword() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                isLoggedIn = true
                print("User logged in with email: \(authResult?.user.email ?? "")")
            }
        }
    }

    // MARK: - Google Sign-In
    func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Missing clientID")
            return
        }

        // Configure Google Sign-In
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Present the Sign-In Flow
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }

            // Safely unwrap the result and tokens
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Google Sign-In failed to retrieve ID token.")
                return
            }

            let accessToken = user.accessToken.tokenString

            // Exchange Google ID Token for Firebase Credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            // Sign in to Firebase with the credential
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In error: \(error.localizedDescription)")
                } else {
                    print("User signed in: \(authResult?.user.email ?? "No Email")")
                }
            }
        }
    }
}

// MARK: - Helper Functions
func getRootViewController() -> UIViewController {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootVC = windowScene.windows.first?.rootViewController else {
        fatalError("Unable to fetch the root view controller.")
    }
    return rootVC
}

#Preview {
    LoginView()
}
