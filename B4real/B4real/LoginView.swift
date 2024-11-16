//
//  LoginView.swift
//  B4real
//
//  Created by thaclaw on 11/15/24.
//
import SwiftUI
import ParseSwift

struct LoginView: View {
    @EnvironmentObject var sessionManager: SessionManager 
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    @State private var signUpMessage: String = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign Up") {
                signUpUser(username: username, password: password)
            }
            .padding()

            Button("Log In") {
                loginUser(username: username, password: password)
            }
            .padding()

            Text(signUpMessage)
                .foregroundColor(.green)
                .padding()

            Text(loginMessage)
                .foregroundColor(.blue)
                .padding()
        }
        .padding()
    }

    // Sign-up function
    func signUpUser(username: String, password: String) {
        var user = User()
        user.username = username
        user.password = password

        user.signup { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    signUpMessage = "Successfully signed up: \(user.username ?? "unknown")"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    signUpMessage = "Sign up failed: \(error.localizedDescription)"
                }
            }
        }
    }

    // Login function
    func loginUser(username: String, password: String) {
        sessionManager.logIn(username: username, password: password) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    loginMessage = "Logged in as: \(user.username ?? "unknown")"
                    sessionManager.isLoggedIn = true // Update login state
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    loginMessage = "Login failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

