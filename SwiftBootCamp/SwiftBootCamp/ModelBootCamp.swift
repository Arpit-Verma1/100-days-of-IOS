//
//  ModelBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 31/10/24.
//

import SwiftUI
struct UserModel:Identifiable{
    let  id: String  = UUID().uuidString
    let displayName:String
    let userName : String
    let followerCount :Int
    let isVerifid : Bool
}


struct ModelBootCamp: View {
    @State var  Users : [UserModel] = [
    UserModel(displayName: "arpit", userName: "arvi", followerCount: 15, isVerifid: true),
    UserModel(displayName: "mansi", userName: "mini", followerCount: 52, isVerifid: false)
    
    ]
    var body: some View {
        NavigationView {
            List{
                ForEach(Users) { user in
                    HStack {
                        Circle()
                            .frame(width: 25,height: 25)
                        VStack{
                            Text(user.displayName)
                            Text("@\(user.userName)")
                        }
                        Spacer()
                        if user.isVerifid {
                            Image(systemName: "checkmark.seal.fill")
                        }
//                        Text(user.followerCount)
                        VStack {
                           
                            Text("followers")
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ModelBootCamp()
}
