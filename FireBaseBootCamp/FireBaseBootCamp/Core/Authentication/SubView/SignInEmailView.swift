//
//  SignInEmailView.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 12/01/25.
//

import SwiftUI



struct SignInEmailView: View {
    @StateObject private var signInEmailViewModel = SignInEmailViewModel()
    @Binding var showSigninView : Bool
    var body: some View {
        NavigationStack {
            VStack{
                TextField("Email", text: $signInEmailViewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                SecureField("Password", text: $signInEmailViewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                Button {
                    Task {
                        do {
                            try await signInEmailViewModel.signUp()
                            showSigninView =  false
                            return
                        }
                        catch {
                            print(error)
                        }
                        do {
                            try await signInEmailViewModel.signIn()
                            showSigninView =  false
                            return
                        }
                        catch {
                            print(error)
                        }
                    }
                    
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height :55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
                
            }
            .padding()
            .navigationBarTitle("Sign In")
        }
    }
}

#Preview {
    SignInEmailView(showSigninView: .constant(false))
}
