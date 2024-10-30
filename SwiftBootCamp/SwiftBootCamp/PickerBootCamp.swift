//
//  PickerBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 29/10/24.
//

import SwiftUI

struct PickerBootCamp: View {
    @State var selection : String = "Most recent"
    @State var options :[String] = [
    "Most recent" , "most popular", "most liked"
    ]
    init() {
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.red
        let attributes : [NSAttributedString.Key:Any] = [
            .foregroundColor : UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    
    var body: some View {
        VStack{
            Picker(selection: $selection
                   , content: {
                ForEach(options.indices) {
                    index in
                    Text(options[index])
                        .tag(options[index])
                }
                
            },
                   label: {Text("Picker")}
            )
            .pickerStyle(SegmentedPickerStyle())
            
            
            
//            Picker(selection: $selection,
//                   label:
//                HStack{
//                    Text("filter :")
//                    Text("\(selection)")
//                
//            }.padding()
//                .padding(.horizontal)
//                .foregroundColor(.white)
//                .background(.blue)
//                .cornerRadius(10)
//                .shadow(color: .blue, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/,x:0,y:10)
//                   ,
//                   content: {
//                ForEach(options, id: \.self, content:{
//                    option in
//                    Text("\(option)")
//                })
//            }
//            )
//            
//            .pickerStyle(MenuPickerStyle())
            
            
            
            
//            HStack {
//                Text("Value choosen :")
//                Text("\(selection)")
//            }
//            Picker (
//                selection: $selection,
//                content: {
//                    ForEach(18..<100) {
//                        number in
//                        Text("\(number)")
//                            .tag("\(number)")
//                    }
//                },
//                label:{ Text("Picker")}
//            )
//            .pickerStyle(.wheel)
            
            
        }
    }
}

#Preview {
    PickerBootCamp()
}
