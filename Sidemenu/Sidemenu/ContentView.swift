import SwiftUI

struct MenuItem: Identifiable {
    var id = UUID()
    var title: String
}

struct MenuContent: View {
    var items = [
        MenuItem(title: "Home"),
        MenuItem(title: "Profile"),
        MenuItem(title: "Rewards"),
        MenuItem(title: "Profile"),
        MenuItem(title: "Home"),
        MenuItem(title: "Profile"),
        MenuItem(title: "Settings"),
        MenuItem(title: "Logout")
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 43/255.0, green: 40/255.0, blue: 74/255.0, alpha: 1.0))
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(items) { item in
                    HStack {
                        Image(systemName: "house").foregroundColor(.white)
                        Text(item.title)
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .multilineTextAlignment(.leading)
                    }
                    .onTapGesture {
                        // Handle menu item tap
                    }
                    Spacer()
                    Divider()
                }
                .padding()
            }
        }
    }
}

struct SideMenu: View {
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.5))
            .opacity(self.menuOpened ? 1 : 0)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                self.toggleMenu()
            }
            
            HStack {
                MenuContent()
                    .frame(width: width, height: UIScreen.main.bounds.height)
                    .offset(x: self.menuOpened ? 0 : -self.width)
                    .animation(.default, value: menuOpened)
                
                Spacer()
            }
        }
    }
}

struct ContentView: View {
    @State var menuOpened = false
    
    var body: some View {
        ZStack {
            Button(action: {
                self.menuOpened.toggle()
            }, label: {
                Text("Open Menu")
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            
            SideMenu(width: UIScreen.main.bounds.width / 1.6, menuOpened: menuOpened, toggleMenu: toggleMenu)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func toggleMenu() {
        menuOpened.toggle()
    }
}

#Preview {
    ContentView()
}

