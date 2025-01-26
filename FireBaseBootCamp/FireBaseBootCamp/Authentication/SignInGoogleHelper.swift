//
//  SignInGoogleHelper.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 26/01/25.
//



import Foundation
import GoogleSignIn
import GoogleSignInSwift


struct GoogleSignInResuls {
    let idToken: String
    let accessToken: String
    let name : String?
    let email : String?
}

final class SignInGoogleHelper {
    @MainActor
    
    func signIn() async throws -> GoogleSignInResuls{
        guard let topVC = Utilities.topViewController() else {
            fatalError("Could not find top view controller.")
        
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            fatalError("Could not obtain id token.")
        }
        let accesToken = gidSignInResult.user.accessToken.tokenString
        
        let name = gidSignInResult.user.profile?.name
        
        let email = gidSignInResult.user.profile?.email
        let token = GoogleSignInResuls(idToken: idToken, accessToken: accesToken,name: name, email: email)
        return token;
    }
}
