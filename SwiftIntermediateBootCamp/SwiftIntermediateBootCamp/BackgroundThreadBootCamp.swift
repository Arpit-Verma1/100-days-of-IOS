//
//  BackgroundThreadBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 03/12/24.
//

import SwiftUI

class BackgroundThreadViewModel : ObservableObject {
    @Published  var dataArray : [String] = []
    
    func fetchData () {
        DispatchQueue.global().async {
            let newData = self.downloadData()
        
            
            DispatchQueue.main.async {
                self.dataArray = newData
            }
         
        }
        
       
    }
    func downloadData () ->[String] {
        var data : [String] = []
        for x in 0..<100 {
            data.append("\(x)")
            print("\(x)")
        }
        return data
        
    }
    
}

struct BackgroundThreadBootCamp: View {
    @StateObject var vm  = BackgroundThreadViewModel()
    
    var body: some View {
        ScrollView {
            VStack (spacing : 10) {
                Text("Load Data")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .onTapGesture {
                        vm.fetchData()
                    }
                
                ForEach(vm.dataArray, id: \.self) { data in
                    Text(data)
                        .font(.headline)
                        .foregroundColor(.red)
                }
                
            }
        }
    }
}

#Preview {
    BackgroundThreadBootCamp(
        
    )
}
