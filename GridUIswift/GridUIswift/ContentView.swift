



import SwiftUI

struct ContentView: View {
    let items = Array(1...100).map({"Num \($0 ) item"})
    let layout = [GridItem(.adaptive(minimum: 100))]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: layout, content: {
                
                ForEach(items,id: \.self){
                    item in Text(item).padding().background(.blue).foregroundColor(.white).cornerRadius(10)
                }
            })
        }}
}

#Preview {
    ContentView()
}
