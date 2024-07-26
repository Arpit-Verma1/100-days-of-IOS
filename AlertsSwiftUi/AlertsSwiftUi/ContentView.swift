import SwiftUI

struct ContentView: View {
    @State private var alertPresented =  false;
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.alertPresented = true
                }, label: {
                    Text("Tap me")
                        .padding()
                        .foregroundColor(.white)
                        .font(.system(size: 35))
                })
                .frame(width: 200, height: 70, alignment: .center)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .alert(isPresented: $alertPresented, content: {
                    Alert(title: Text("Did you like it?"), message: Text("Day2 Alert Dialog Learning"), dismissButton: .default(Text("Yes, I loved It")))
                })
            }
            .navigationTitle("Alerts Screen")
        }
    }
}

#Preview {
    ContentView()
}

