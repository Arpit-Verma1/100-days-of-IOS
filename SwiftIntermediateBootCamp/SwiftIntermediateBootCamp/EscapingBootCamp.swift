//
//  EscapingBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 05/12/24.
//

import SwiftUI


class EscapingViewModel: ObservableObject {
    @Published var text: String = "Hello"
    
    func getData() {
        downloadData3 { [weak self] data in
            self?.text = data
        }
        downloadData4 { [weak self] returnedResult in
            self?.text = returnedResult.data
        }
    }
    
    func downloadData() -> String{
        return "New Data"
    }
    
    func downloadData2(completionHandler :(_ data : String) -> Void) {
        completionHandler("new data")
    }
    
    func downloadData3(completionHandler : @escaping(_ data : String) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completionHandler("new data")
        }
       
    }
    
    func downloadData4(completionHandler : @escaping(DownloadResult) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let result = DownloadResult(data: "new data")
            completionHandler(result)
        }
       
    }
    func downloadData5(completionHandler : @escaping DownloadComplettion) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let result = DownloadResult(data: "new data")
            completionHandler(result)
        }
       
    }
    
}


struct DownloadResult  {
    let data : String
}

typealias DownloadComplettion =  (DownloadResult) -> Void


struct EscapingBootCamp: View {
    @StateObject var vm = EscapingViewModel()
    var body: some View {
        Text(vm.text)
            .fontWeight(.bold)
            .foregroundStyle(.red)
            .onTapGesture {
                vm.getData()
                
            }
    }
}

#Preview {
    EscapingBootCamp()
}
