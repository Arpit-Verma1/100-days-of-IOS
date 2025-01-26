//
//  RootView.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 12/01/25.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView : Bool = false
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    ProfileView(showSignInView: $showSignInView)
//                    SettingsView(showSignInView: $showSignInView)
                }
            }
        }.onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
            
        }
        .fullScreenCover (isPresented: $showSignInView) {
           
            AuthenticationView(showSigninView: $showSignInView)
            
        }
    }
}

#Preview {
    RootView()
}
