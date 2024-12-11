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
    @EnvironmentObject var appState: AppState // login state
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Title
                Text("Login to FoodLens")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)

                // Email Field
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }

                // Password Field
                VStack(alignment: .leading, spacing: 10) {
                    Text("Password")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }

                // Login Button
                Button(action: {
                    loginWithEmailPassword()
                }) {
                    Text("Log In")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                }

                // Link to Sign Up page
                NavigationLink(destination: SignUpView()) {
                    Text("Create An Account")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                }

                Divider()
                
                Text("Or")
                    .font(.caption)
                    .multilineTextAlignment(.center)

                // Google Sign-In Button
                Button(action: {
                    loginWithGoogle()
                }) {
                    HStack {
                        Image(systemName: "globe")
                        Text("Sign In with Google")
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                }
            }
            .padding()
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Email/Password Login
    func loginWithEmailPassword() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                appState.isLoggedIn = true
                handleUserLogin() // Update firebase if need
                print("User logged in with email: \(authResult?.user.email ?? "")")
            }
        }
    }

    // Google Sign-In
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
                print("Firebase Auth Result: \(authResult?.user.email ?? "No user email")")
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                } else {
                    appState.isLoggedIn = true
                    handleUserLogin() // Update firebase if need
                    print("User signed in: \(authResult?.user.email ?? "No Email")")
                }
            }
        }
    }
}


// Helper Functions
func getRootViewController() -> UIViewController {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootVC = windowScene.windows.first?.rootViewController else {
        fatalError("Unable to fetch the root view controller.")
    }
    return rootVC
}

// Helper to run after each login or signup -> check if user's entry exists in users collection, if not create new one
func handleUserLogin() {
    guard let user = Auth.auth().currentUser else {
        print("No authenticated user")
        return
    }

    let db = Firestore.firestore()
    let userRef = db.collection("users").document(user.uid)

    // Check if the document exists
    userRef.getDocument { (document, error) in
        if let error = error {
            print("Error fetching user document: \(error.localizedDescription)")
            return
        }

        if let document = document, document.exists {
            // User document already exists
            print("User document exists")
        } else {
            // Create a new document for the user
            userRef.setData([
                "email": user.email ?? "",
                "createdAt": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    print("Error creating user document: \(error.localizedDescription)")
                } else {
                    print("User document successfully created")
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
