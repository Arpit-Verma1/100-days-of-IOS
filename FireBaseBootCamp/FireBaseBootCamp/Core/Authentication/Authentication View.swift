//
//  Authentication View.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 12/01/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift






struct AuthenticationView: View {
    @Binding  var showSigninView :Bool
    @StateObject private var viewModel = AuthenticationViewModel()
    var body: some View {
        NavigationStack{
            VStack {
                
                Button (action: {

                    Task {
                        do {
                            try await viewModel.signInAnonmously()
                            showSigninView = false
                        }
                        catch {
                            print("error \(error)")
                        }
                    }
                }, label: {
                    Text("Sign In Anonymously")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height :55)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                })
                NavigationLink {
                    SignInEmailView(showSigninView: $showSigninView)
                } label: {
                    Text("Sign In With Email")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height :55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(
                    scheme: .dark,
                    style: .wide,
                    state: .normal
                    
                )) {
                    Task {
                        do {
                            try await viewModel.signInWithGoogle()
                            showSigninView = false
                        }
                        catch {
                            print("error \(error)")
                        }
                    }
                    
                }
                Spacer()
            }.padding()
                .navigationTitle("Sign In")
        }
    }
}

#Preview {
    AuthenticationView(showSigninView: .constant(false))
}
