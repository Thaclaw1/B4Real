//
//  B4RealApp.swift
//  B4Real
//
//  Created by thaclaw on 10/19/24.
//
//=============================================================================
// PROGRAMMER: Ethan Robinson
// PANTHER ID: 6351979
//
// CLASS: COP4655
// SECTION: Your class section: U01
// SEMESTER: The current semester: Fall 2024
//
// CERTIFICATION: I certify that this work is my own and that
// none of it is the work of any other person.
//=============================================================================
import SwiftUI
import ParseSwift

@main
struct B4realapp: App {
    @StateObject private var sessionManager = SessionManager()

        init() {
            ParseSwift.initialize(applicationId: "luJ66Um7ZxHs7Pl9zDq2DSrBd8XQV91w17I5yefl",
                                  clientKey: "RjBxghYd1L2a7DDrDkjLvqI9g0joke19HHm6IdqJ",
                                  serverURL: URL(string: "https://parseapi.back4app.com")!)
        }

        var body: some Scene {
            WindowGroup {
                if sessionManager.isLoggedIn {
                    FeedView()
                        .environmentObject(sessionManager)
                } else {
                    LoginView()
                        .environmentObject(sessionManager)
                }
            }
        }
    }
