//
//  weakSelfBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 04/12/24.
//

import SwiftUI

struct weakSelfBootCamp: View {
    @AppStorage("count") var count : Int?
    
    init() {
        count = 0
    }
    
    var body: some View {
        NavigationView {
            
            NavigationLink(destination: WeakSelfSecondScreen()) {
                Text("Navigate to Second Screen")
            }
            .navigationTitle("Screen 1")
        }.overlay {
            Text("\(count ?? 0)")
                .font(.largeTitle)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
                
        }
    }
}

struct WeakSelfSecondScreen : View {
    
    @StateObject var vm = WeakSelfSecondScreenViewModel()
    
    var body: some View {
        VStack {
            Text("Second Screen")
                .font(.largeTitle)
                .foregroundStyle(Color.red)
            if let data = vm.data {
                Text(data)
            }
        }
        
    }
}

class WeakSelfSecondScreenViewModel: ObservableObject {
    @Published var data: String? = nil
    
    init() {
        print("INTIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
            getData()
        
    }
    
    deinit {
        
        print("DEINITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 500) {
            [weak self ] in
            self?.data = "Old data"
        }
       
    }
    
}

#Preview {
    weakSelfBootCamp()
}
