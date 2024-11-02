//
//  appStorageBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 01/11/24.
//

import SwiftUI

struct appStorageBootCamp: View {
    @AppStorage("name") var currentUser : String?
    @State var currentUserName : String?
    var body: some View {
        VStack {
            Text(currentUser ?? "add your name")
            Text(currentUserName ?? "add your name")
            Button(action: {
                currentUser = "arpit"
                UserDefaults.standard.setValue("arpit", forKey: "name")
            }, label: {Text("Save")})
        }
        .onAppear(perform:  {
            currentUserName = UserDefaults.standard.string(forKey: "name")
        })
    
    }
}

#Preview {
    appStorageBootCamp()
}
