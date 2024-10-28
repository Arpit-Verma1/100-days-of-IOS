//
//  actionSheetBootCamp.swift
//  Buttons
//
//  Created by arpit verma on 28/10/24.
//

import SwiftUI

struct actionSheetBootCamp: View {
    @State var showActionSheet : Bool = false
    @State var actionOption : ActionOptions = .isMypost
    
    
    enum ActionOptions {
        case isMypost
        case isYourPost
    }
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 50,height: 50)
                Text("arpit verma")
                Button(action: {
                    showActionSheet.toggle()
                    actionOption = .isYourPost
                }, label: {
                   Text("open sheet")
                })
            }
        }
        .actionSheet(isPresented: $showActionSheet, content: {
            	
            @State var title :String = "this is title"
            let shareButton : ActionSheet.Button = .default(Text("share it"))
            let deleteButton : ActionSheet.Button = .destructive(Text("delete it"))
        
            switch actionOption {
            case .isMypost :
              return   ActionSheet(title: Text(title),
                buttons: [shareButton,deleteButton]
                )
            case .isYourPost :
             return    ActionSheet(title:Text(title),
                buttons: [shareButton])
                
            }
        })
    }
}

#Preview {
    actionSheetBootCamp()
}
