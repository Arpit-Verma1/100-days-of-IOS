//
//  ContentView.swift
//  Redacted
//
//  Created by arpit verma on 26/07/24.
//

import SwiftUI

struct ContentView: View {
    @State var isloading = true
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    ForEach(0...10, id:\.self ) {
                        _ in
                        PostView().frame(height: 150)
                            .padding(12)
                    }
                }.redacted(reason: isloading ?.placeholder:[])
            }.navigationTitle("Facebook").onAppear(perform: {
                fetchData()
            })
        }
    }
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now()+4)
        {
            isloading =  true
        }
    }
    
}
struct PostView :View{
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                    width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,
                    height: 100,
                    alignment:  .center
                    ).unredacted()
                
                    Text("Arpit Verma")
                        .bold().font(.system(size: 22))
             
                
                
            }
            Text("this is post description text so it goes too long").font(.system(size: 24))
            Text("this is post description text so it goes too long").font(.system(size: 24))
            
        }
    }
    
}

#Preview {
    ContentView()
}
