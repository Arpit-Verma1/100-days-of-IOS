//
//  TextFieldBootCamp.swift
//  Buttons
//
//  Created by arpit verma on 28/10/24.
//

import SwiftUI

struct TextFieldBootCamp: View {
    @State var textfieldText : String = ""
    @State var listText :[String] = []
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                TextField("Type something..", text:$textfieldText
                )
                .padding(20)
                .foregroundColor(.red)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .font(.headline)
                
                Button(action: {
                    addText()
                }, label: {
                    Text("Save")                 })
                .padding()
                .frame(maxWidth: .infinity)
                .background(textAppropriate() ? Color.blue: Color.gray)
                .foregroundColor(.white)
                
                .cornerRadius(10)
                
                ForEach(listText, id: \.self ) {
                    data in
                    Text(data)
                }
                
            }.padding()
            
            .navigationTitle("Textfield Bootcamp")
        }
    }
    func addText() {
        listText.append(textfieldText)
        textfieldText = ""
    }
    func textAppropriate () ->Bool {
        if textfieldText.count>=4 {
            return true}
        return false
    }
}

#Preview {
    TextFieldBootCamp()
}
