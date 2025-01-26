//
//  AuthenticationViewModel.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 26/01/25.
//

import Foundation


//The @MainActor ensures that code is executed on the main thread since UI updates must occur on the main thread in iOS/macOS applications.
@MainActor
final class AuthenticationViewModel : ObservableObject {
    
    
    
    
    func signInWithGoogle() async throws {
        let helper = SignInGoogleHelper()
        let token = try await helper.signIn()
        let authResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: token)
        try await UserManager.shared.createNewUser(auth: authResult)
        
    }
    
    func signInAnonmously() async throws {
    
       let authResult = try await AuthenticationManager.shared.signInAnonmous( )
        try await UserManager.shared.createNewUser(auth: authResult)
        
       
        
    }
}
