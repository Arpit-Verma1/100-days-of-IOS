//
//  TypeAliasBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 04/12/24.
//

import SwiftUI

struct MoviewModel {
    let title : String
    let director : String
    let count : Int
}

typealias TVMoviewModel = MoviewModel

struct TypeAliasBootCamp: View {
    
    @State var  item : TVMoviewModel = TVMoviewModel(title: "Star Wars", director: "George Lucas", count: 10)
    var body: some View {
        VStack {
            Text("\(item.title)")
            Text("\(item.count)")
            Text("\(item.director)")
        }
    }
}

#Preview {
    TypeAliasBootCamp()
}
