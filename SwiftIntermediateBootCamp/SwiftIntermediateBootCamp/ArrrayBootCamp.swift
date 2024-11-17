//
//  ArrrayBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 16/11/24.
//

import SwiftUI


struct Usermodel : Identifiable {
    let id: Int
    let name: String
    let points: Int
    let isVerified: Bool
}


class ArrayModificationViewModel: ObservableObject {
    
    @Published var dataArray : [Usermodel] = []
    @Published var filteredArray: [Usermodel] = []
    @Published var mappedArray: [String] = []
        init () {
            getUsers()
            updateFilteredArray()
    }
    func getUsers() {
        let user1 = Usermodel(id: 1, name: "Arpit", points: 100, isVerified: true)
        let user2 = Usermodel(id: 2, name: "Rahul", points: 200, isVerified: false)
        let user3 = Usermodel(id: 3, name: "Amit", points: 300, isVerified: true)
        let user4 = Usermodel(id: 4, name: "Shubham", points: 400, isVerified: false)
        let user5 = Usermodel(id: 5, name: "Pankaj", points: 500, isVerified: true)
        let user6 = Usermodel(id: 6, name: "Sachin", points: 600, isVerified: false)
        let user7 = Usermodel(id: 7, name: "Rohit", points: 700, isVerified: true)
        let user8 = Usermodel(id: 8, name: "mansi", points: 800, isVerified: false)
        let user9 = Usermodel(id: 9, name: "eshita", points: 900, isVerified: true)
        let user10 = Usermodel(id: 10, name: "radhika", points: 1000, isVerified: false)
        self.dataArray.append(contentsOf: [
            user1,
            user2,
            user3,
            user4,
            user5,
            user6,
            user7,
            user8,
            user9,
            user10
            
        ])
        
    }
    func updateFilteredArray
    () {
        // sort
        /*
        filteredArray = dataArray.sorted(by: { user1, user2 in
        return user1.points > user2.points
        })
         */
        
        // filter
        /*
        filteredArray = dataArray.filter({ (user) ->Bool in
            return user.points > 600
        })
         */
        
        // mapped Array
        mappedArray = dataArray.map({ (user) -> String in
            return user.name
        })
        
        
    }
}

struct ArrrayBootCamp: View {
    @StateObject var vm = ArrayModificationViewModel()
    
    
    
    var body: some View {
        ScrollView
        {
            VStack (spacing: 10) {
                ForEach(vm.mappedArray, id:\.self) { user in
                    Text(user)
                }
                ForEach(vm.filteredArray) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        HStack {
                            Text("points \(user.points)")
                            Spacer()
                            if user.isVerified {
                                Image(systemName: "checkmark.circle.fill")
                                
                            }
                        }
                    }
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ArrrayBootCamp()
}
