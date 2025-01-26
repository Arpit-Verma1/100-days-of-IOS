//
//  AuthenticationManager.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 12/01/25.
//

import Foundation
import FirebaseAuth


struct AuthDataResultModel{
    let uid: String
    let email: String?
    let photoUrl: String?
    let anonmous : Bool
    
    init(user : User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.anonmous = user.isAnonymous
        
    }
}

enum  AuthProviderOptions: String {
    case email = "password"
    case google =  "google.com"
}

final class AuthenticationManager{
    static let shared = AuthenticationManager()
    
    private init(){}
    
    
    func getAuthenticatedUser()  throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else { throw  URLError(.badServerResponse)}
        return AuthDataResultModel(user: user)
    }
    
    func getProvider () throws ->[AuthProviderOptions]{
        guard let providerData = Auth.auth().currentUser?.providerData else { throw URLError(.badServerResponse)
            
            
        }
        var providers : [AuthProviderOptions] = []
        
        for provider in providerData {
            if let option =  AuthProviderOptions(rawValue : provider.providerID)
                {
                providers.append(option)
            }
            else {
                assertionFailure("Provier Option not found : \(provider.providerID  )")
            }
        }
        
        return providers
    }
    // use to tell we get value but can't be used in future
    
    
    
    func  signOut()  throws {
        try   Auth.auth().signOut()
    }
    
}

// MARK : SIGN IN EMAIL
extension AuthenticationManager {
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult = try await FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    @discardableResult
    func signInUser (email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult = try await FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
    func resetPassword(email : String) async throws{
        try await  Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password : String) async throws{
        guard let user = Auth.auth().currentUser else { throw  URLError(.badServerResponse)}
        try  await user.updatePassword(to : password)
    }
    
    
    func updateEmail(email : String) async throws{
            guard let user = Auth.auth().currentUser else { throw  URLError(.badServerResponse)}
        try  await user.updateEmail(to: email)
    }
}

// MARK : SIGN IN WITH SSO
extension AuthenticationManager {
    
    @discardableResult
    func signInWithGoogle(tokens:GoogleSignInResuls) async throws-> AuthDataResultModel{
        
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken , accessToken: tokens.accessToken)
   
        return try await signIN(credential: credential)
    }
    
    func signIN(credential :AuthCredential) async throws -> AuthDataResultModel{
        let authDataResult = try await FirebaseAuth.Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
}

//  MARK: SIGN IN ANONMOUSLY
extension AuthenticationManager {
    
    @discardableResult 
    func signInAnonmous() async throws -> AuthDataResultModel{
        let authDataResult = try await FirebaseAuth.Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func linkEmail(email:String , password: String) async throws -> AuthDataResultModel{
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
       return  try await  linkCredential(credential: credential)
        
    }
    func linkGoogle (tokens:GoogleSignInResuls) async throws-> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken , accessToken: tokens.accessToken)
        return  try await  linkCredential(credential: credential)
        
    }
    private func linkCredential(credential:AuthCredential) async throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL  )
        }
        let authDataResult = try await user.link(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
