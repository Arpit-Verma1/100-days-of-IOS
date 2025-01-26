//
//  ProfileView.swift
//  FireBaseBootCamp
//
//  Created by Arpit Verma on 26/01/25.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser?   = nil
    func loadCurrentUser()async throws{
        let authResult  = try  AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await  UserManager.shared.getUser(userId: authResult.uid)    }
}



struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding  var showSignInView: Bool
    var body: some View {
        List{
            if let user = viewModel.user {
                Text("userId : \(user.userId    )")
                
                if let isAnnonynousUser  = user.isAnonymous{
                    Text("isAnnonymous : \(isAnnonynousUser.description)")
                        .foregroundColor(.red)
                }
            }
        }
        .task{
            try? await  viewModel.loadCurrentUser()
        }
        
        .navigationTitle("Profile")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink{
                    SettingsView(showSignInView: $showSignInView)
                }
                label :{
                    Image(systemName: "gear")
                        .font(.headline)
                }
               
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
