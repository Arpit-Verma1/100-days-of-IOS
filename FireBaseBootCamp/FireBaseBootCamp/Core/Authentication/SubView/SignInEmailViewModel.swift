//
//  SignInEmailViewModel.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 26/01/25.
//

import Foundation


final class SignInEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    
    
    func signIn() async throws{
        guard !email.isEmpty , !password.isEmpty else {
            print("No email or password found")
            return  }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        }
    
    func signUp() async throws{
        guard !email.isEmpty , !password.isEmpty else {
            print("No email or password found")
            return  }
        let authResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authResult)
        }
    
    
}
