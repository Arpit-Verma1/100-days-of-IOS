//
//  ContentView.swift
//  Snackbar
//
//  Created by arpit verma on 18/07/24.
//
import PopupView
import SwiftUI

struct ContentView: View {
    @State var isShowing=false;
    var body: some View {
        NavigationView{
            VStack {
                Button(action: {
                    self.isShowing=true
                }, label: {Text("Tap me ").frame(
                    width: 150,
                    height: 50
                    
                ).background(Color.red).foregroundColor(.white).font(.system(size: 25).bold()).cornerRadius(10)})
            }
        }.popup(isPresented: $isShowing){
            Toast()
        }customize: {
            $0
                .type(.floater(verticalPadding: 10, horizontalPadding: 10, useSafeAreaInset: true))
            .animation(.bouncy)
            .autohideIn(3)
            .position(.top)
            .closeOnTap(true)
            
        }
        .navigationTitle(Text("title"))
    }
    }
struct Toast:View{
    var body:some  View {
        ZStack {
            Color.green
            HStack {
                Image(systemName: "house").resizable().frame(
                    width: 30,
                    height: 30,
                    alignment: .center
                ).padding().foregroundColor(.white)
                Text("10 New post ").foregroundColor(.white).font(.system(size:25).bold())
            }.padding()
        }.cornerRadius(10).frame(
            height: 20
        ).padding()
    }
}

#Preview {
    ContentView()
}
