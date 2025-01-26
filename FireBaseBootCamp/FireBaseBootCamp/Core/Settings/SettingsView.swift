//
//  SettingsView.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 12/01/25.
//

import SwiftUI




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
            Button ("Delete Account" ,role: .destructive) {
                Task {
                    do {
                        
                        try await   settingsViewModel.deleteUser()
                        showSignInView = true
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            
            if settingsViewModel.authProviders.contains(.email) {
                emailSection
            }
            if settingsViewModel.authUser?.anonmous == true {
                anonymousSection
            }
            

            
        }.onAppear{
            settingsViewModel.loadAuthProvider()
            settingsViewModel.loadAuthenticateduser()
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
    
    
    private var anonymousSection : some View {
        Section {
            Button ("Link Google" ) {
                Task {
                    do {
                        
                        try await settingsViewModel.linkGoogle()
                        print("Google Linked")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            Button ("Link Email" ) {
                Task {
                    do {
                        
                        try await settingsViewModel.linkEmail()
                        print("Email Link")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            
        } header: {
            Text("Create Account")
        }
    }
}

#Preview {
    SettingsView( showSignInView: .constant(true))
}
