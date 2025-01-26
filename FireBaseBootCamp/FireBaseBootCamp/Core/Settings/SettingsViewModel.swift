//
//  SettingsViewModel.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 26/01/25.
//

import Foundation


@MainActor
final class SettingsViewModel : ObservableObject {
    
    
    @Published var authProviders: [AuthProviderOptions] = []
    @Published var authUser : AuthDataResultModel? = nil
    
    func loadAuthProvider() {
        if let providers = try? AuthenticationManager.shared.getProvider(){
            authProviders = providers
        }
        
    }
    
    func loadAuthenticateduser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    
    func deleteUser() async throws {
        try await  AuthenticationManager.shared.deleteUser()
    }
    
    func resetPassword()async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await  AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updatePassword () async throws {
        let password = "121"
        try await  AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func updateEmail () async throws {
        let email = "arpit@gmail.com"
        try await  AuthenticationManager.shared.updateEmail(email: email)
    }
    
    
    func linkGoogle() async throws {
        let helper = SignInGoogleHelper()
        let token = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.signInWithGoogle(tokens: token)
    }
    func linkEmail() async throws {
        let email = "abc@gmail.com"
        let password = "12345678"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
    
    
}
