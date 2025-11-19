//
//  AuthManager.swift
//  Resolution
//
//  Created by June Eguilos on 11/19/25.
//

import Foundation
import Supabase

class AuthManager: ObservableObject{
    @Published var isSignedIn = false
    @Published var currentUser: User?

    init(){
        Task{
            await checkAuthStatus()
        }
    }

    func checkAuthStatus() async {
        do {
            let user = try await supabase.auth.user()
            await MainActor.run{
                self.currentUser = user
                self.isSignedIn = true
            }
        } catch {
            await MainActor.run{
                self.isSignedIn = false
                self.currentUser = nil
            }
        }
    }

    func signUp(email: String, password: String) async throws{
        try await supabase.auth.signUp(email: email, password: password)
        await checkAuthStatus()
    }

    func signIn(email: String, password: String) async throws{
        try await supabase.auth.signIn(email: email, password: password)
        await checkAuthStatus()
    }


}
