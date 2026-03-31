import SwiftUI

enum ZupetTab {
    case home
    case featured
    case collection
    case profile
}

struct MainTabView: View {
    
    @State private var selectedTab: ZupetTab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .featured:
                    FeaturedPetView()
                case .collection:
                    Text("Collection")
                case .profile:
                    Text("Profile")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ZupetBottomNavBar(selectedTab: $selectedTab)
        }
    }
}



#Preview {
    MainTabView()
}

