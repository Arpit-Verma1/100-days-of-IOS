import SwiftUI

struct CircleButtonView: View {
    let iconName: String

    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle().foregroundColor(Color.theme.background)
            )
            .shadow(
                color: Color.theme.accent.opacity(0.5),
                radius: 20,
                x: 0.0,
                y: 0.0
            )
            .padding(.bottom, 10)
    }
}

#Preview(traits: .sizeThatFitsLayout){
    Group {
        CircleButtonView(iconName: "plus")
            .padding()
            .previewLayout(.sizeThatFits)
            .frame(width: 100, height: 100) // Explicitly setting frame for preview
        
        CircleButtonView(iconName: "plus")
            .padding()
            .previewLayout(.sizeThatFits)
            .frame(width: 100, height: 100) // Explicitly setting frame for preview
            .colorScheme(.dark)
    }
}

