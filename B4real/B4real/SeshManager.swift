//
//  SeshManager.swift
//  B4real
//
//  Created by thaclaw on 11/16/24.
//

import ParseSwift
import SwiftUI

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = User.current != nil

    func logIn(username: String, password: String, completion: @escaping (Result<User, ParseError>) -> Void) {
        User.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = true
                case .failure:
                    self?.isLoggedIn = false
                }
                completion(result)
            }
        }
    }

    func logOut() {
        User.logout { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = false
                case .failure(let error):
                    print("Logout failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
