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
        
        self.user = try await  UserManager.shared.getUser(userID: authResult.uid)   }
    
    
    func togglePremiumStatus()async throws{
        guard let user else {
            return
        }
        let currentValue = user.isPremium ?? false
        
        //        user.togglePremiumStatus();
        Task {
            try await   UserManager.shared.updatePremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await  UserManager.shared.getUser(userID: user.userId)
        }
    }
    
    
    func addUserPrefrences (text : String) {
        guard let user else {
            return
        }
        Task  {
            try await UserManager.shared.addUserPrefrence(userID: user.userId, prefrences: text)
            self.user = try await  UserManager.shared.getUser(userID: user.userId)
        }
    }
    
    func removeUserPrefrences (text : String) {
        guard let user else {
            return
        }
        Task  {
            try await UserManager.shared.removeUserPrefrence(userID: user.userId, prefrences: text)
            self.user = try await  UserManager.shared.getUser(userID: user.userId)
        }
    }
    
    func addFavouriteMovie () {
        guard let user else {
            return
        }
        let  movie : Movie = Movie(id: "1", title: "godjila", isPopular: true)
        Task  {
            try await UserManager.shared.addFavouriteMovie(userID: user.userId, movie: movie)
            self.user = try await  UserManager.shared.getUser(userID: user.userId)
        }
    }
    func removeFavouriteMovie () {
        guard let user else {
            return
        }
        
        Task  {
            try await UserManager.shared.removeFavouriteMovie(userID: user.userId)
            self.user = try await  UserManager.shared.getUser(userID: user.userId)
        }
    }

}



struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    @Binding  var showSignInView: Bool
    
    
    private func prefrencesIsSelected(text: String) ->Bool {
        viewModel.user?.prefrences?.contains(text ) == true
    }
    
    let prefrenceOption  : [String] = ["Sports", "Movies", "Books"]
    var body: some View {
        List{
            if let user = viewModel.user {
                Text("userId : \(user.userId    )")
                
                if let isAnnonynousUser  = user.isAnonymous{
                    Text("isAnnonymous : \(isAnnonynousUser.description)")
                        .foregroundColor(.red)
                }
                
                Button {
                    Task {
                        try await viewModel.togglePremiumStatus()
                    }
                } label : {
                    Text ("User is premium: \((user.isPremium ??  false).description.capitalized)")
                }
                VStack{
                    HStack {
                        
                        ForEach(prefrenceOption, id : \.self) {
                            string in
                            Button (string) {
                                if prefrencesIsSelected(text: string) {
                                    viewModel.removeUserPrefrences(text: "")
                                }
                                else {
                                    viewModel.addUserPrefrences(text: string)
                                }
                            }.font(.headline)
                
                                .buttonStyle(.borderedProminent)
                                .tint(prefrencesIsSelected(text: string) ? .green : .red)
                        }
                        
                    }
                    Text("User preferences: \((user.prefrences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button {
                    if user.favoriteMovie == nil {
                        viewModel.addFavouriteMovie()
                    }
                    else {
                        viewModel.removeFavouriteMovie()
                    }
                } label : {
                    Text ("Favourite Movie: \(user.favoriteMovie?.title ?? "No Movie")")
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
