//
//  SignUpView.swift
//  FoodLens
//
//  Created by Harry Ahn on 9/12/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var showSuccess = false
    @State private var errorMessage = ""
    @State private var isRedirectingToLogin = false

    var body: some View {
        VStack(spacing: 30) {
            // Title
            Text("Create an Account")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)

            // Email Input
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

            // Password Input
            VStack(alignment: .leading, spacing: 10) {
                Text("Password")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            // Sign Up Button
            Button(action: {
                signUpWithEmailPassword()
            }) {
                Text("Sign Up")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showSuccess) {
            Alert(
                title: Text("Success"),
                message: Text("Your account has been created successfully"),
                dismissButton: .default(Text("OK"), action: {
                    isRedirectingToLogin = true
                })
            )
        }
    }

    func signUpWithEmailPassword() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                showSuccess = true
                print("User signed up: \(authResult?.user.email ?? "")")
            }
        }
    }
}
