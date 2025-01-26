//
//  Authentication View.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 12/01/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift




//The @MainActor ensures that code is executed on the main thread since UI updates must occur on the main thread in iOS/macOS applications.
@MainActor
final class AuthenticationViewModel : ObservableObject {
    
    
    
    
    func signInWithGoogle() async throws {
        let helper = SignInGoogleHelper()
        let token = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: token)
       
        
    }
}

struct AuthenticationView: View {
    @Binding  var showSigninView :Bool
    @StateObject private var viewModel = AuthenticationViewModel()
    var body: some View {
        NavigationStack{
            VStack {
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
