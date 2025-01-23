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
    
    init(user : User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        
    }
}

final class AuthenticationManager{
    static let shared = AuthenticationManager()
    
    private init(){}
    
    
    func getAuthenticatedUser()  throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else { throw  URLError(.badServerResponse)}
        return AuthDataResultModel(user: user)
    }
    
    // use to tell we get value but can't be used in future
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
    
    
    func  signOut()  throws {
        try   Auth.auth().signOut()
    }
    
}
