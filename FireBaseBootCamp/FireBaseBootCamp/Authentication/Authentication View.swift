//
//  Authentication View.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 12/01/25.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding  var showSigninView :Bool
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
                Spacer()
            }.padding()
                .navigationTitle("Sign In")
        }
    }
}

#Preview {
    AuthenticationView(showSigninView: .constant(false))
}
