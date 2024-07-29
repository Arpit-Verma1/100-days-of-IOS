//
//  ContentView.swift
//  Refreshable
//
//  Created by arpit verma on 29/07/24.
//

import SwiftUI
struct User:Codable{
    let name:String
    let email:String
}
class UsersViewModel:ObservableObject{
    @Published var users = [
    User(name: "Arpit", email: "arpitv747@gmail.com")
    ]
    
    func refreshUsers(){
        guard URL(string:"https://jsonplaceholder.typicode.com/users") != nil else {
            return
        }
    }
    let task = URLSession.shared.dataTask(with: url) {
        data, _, error in guard let data = data, error == nil else {
            return
        }
    }
    
    do {
        let newUsers = try JSONDecoder().decode([User].self, from: Data)
       
    }
    catch{
        print(error)
    }
    
}


struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
