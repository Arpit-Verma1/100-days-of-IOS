//
//  SettingsView.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 12/01/25.
//

import SwiftUI


@MainActor
final class SettingsViewModel : ObservableObject {
    
    
    @Published var authProviders: [AuthProviderOptions] = []
    
    func loadAuthProvider() {
        if let providers = try? AuthenticationManager.shared.getProvider(){
            authProviders = providers
        }
            
    }
    
    func logOut() throws {
       try AuthenticationManager.shared.signOut()
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
    
    
    
}

struct SettingsView: View {
    @StateObject var settingsViewModel = SettingsViewModel()
    @Binding var showSignInView : Bool
    var body: some View {
        List {
            Button ("Log Out" ) {
                Task {
                    do {
                        
                        try settingsViewModel.logOut()
                        showSignInView = true
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            
            if settingsViewModel.authProviders.contains(.email) {
                emailSection
            }
            

            
        }.onAppear{
            settingsViewModel.loadAuthProvider()
        } .navigationTitle("Settings")
       
    }
}

extension SettingsView {
    private var emailSection : some View {
        Section {
            Button ("Reset Password" ) {
                Task {
                    do {
                        
                        try await settingsViewModel.resetPassword()
                        print("reset password")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            Button ("Update  Password" ) {
                Task {
                    do {
                        
                        try await settingsViewModel.updatePassword()
                        print("update password")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            Button ("Update  Email" ) {
                Task {
                    do {
                        
                        try await settingsViewModel.updateEmail()
                        print("update email")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
        } header: {
            Text("EMAIL FUNCTUIONS")
        }
    }
}

#Preview {
    SettingsView( showSignInView: .constant(true))
}
