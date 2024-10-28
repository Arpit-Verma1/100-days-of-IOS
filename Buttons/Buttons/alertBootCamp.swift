//
//  alertBootCamp.swift
//  Buttons
//
//  Created by arpit verma on 28/10/24.
//

import SwiftUI

struct alertBootCamp: View {
    @State var showalert : Bool = false
    @State var myAlert : alertTypes? = nil
    
    enum alertTypes {
        case success
        case failure
    }
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            VStack {
                Button(action: {
                    showalert.toggle()
                }, label: {
                    Text("Show alert1")
                })
                Button(action: {
                    showalert.toggle()
                    myAlert = .failure
                }, label: {
                    Text("Show alert2")
                })
            }
            
            
        }
        .alert(isPresented: $showalert, content: {
            showAlert()
        })
    }
    
    func showAlert() -> Alert {
        switch myAlert {
        
        case .success :
            return Alert(title: Text("this is succces alert"))
        case .failure :
            return Alert(title: Text("this is error alert"), message: Text("error discription"), primaryButton: .cancel(Text("cancel it"), action: {}), secondaryButton: .default(Text("button")))
        default :
            return Alert(title: Text("this is default alert"))
        }
    }
}

#Preview {
    alertBootCamp()
}
