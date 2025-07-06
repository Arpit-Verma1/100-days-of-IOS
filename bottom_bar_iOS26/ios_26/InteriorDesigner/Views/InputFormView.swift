import SwiftUI

struct InputFormView: View {
    @ObservedObject var viewModel: InteriorDesignViewModel
    @State private var showingColorPicker = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 8) {
                    Text("AI Interior Designer")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                    
                    Text("Create your perfect space with AI")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 20)
                
                // Room Type Selection
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundStyle(.blue)
                        Text("Room Type")
                            .font(.headline)
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(RoomType.allCases, id: \.self) { roomType in
                            RoomTypeCard(
                                roomType: roomType,
                                isSelected: viewModel.designInput.roomType == roomType
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    viewModel.designInput.roomType = roomType
                                }
                            }
                        }
                    }
                }
                
                // Style Preference
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundStyle(.purple)
                        Text("Design Style")
                            .font(.headline)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(DesignStyle.allCases, id: \.self) { style in
                                StyleCard(
                                    style: style,
                                    isSelected: viewModel.designInput.stylePreference == style
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        viewModel.designInput.stylePreference = style
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // Color Mood Slider
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "paintpalette.fill")
                            .foregroundStyle(viewModel.colorMoodColor)
                        Text("Color Mood")
                            .font(.headline)
                        Spacer()
                        Text(viewModel.colorMoodDescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Warm")
                                .font(.caption)
                                .foregroundStyle(.orange)
                            Spacer()
                            Text("Cool")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                        
                        Slider(value: $viewModel.designInput.colorMood, in: 0...1)
                            .tint(viewModel.colorMoodColor)
                    }
                    .padding(.horizontal, 5)
                }
                
                // Budget Range
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(.green)
                        Text("Budget Range")
                            .font(.headline)
                    }
                    
                    Picker("Budget", selection: $viewModel.designInput.budgetRange) {
                        ForEach(BudgetRange.allCases, id: \.self) { budget in
                            VStack(alignment: .leading) {
                                Text(budget.rawValue)
                                    .font(.headline)
                                Text(budget.range)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .tag(budget)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Room Size
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "ruler.fill")
                            .foregroundStyle(.indigo)
                        Text("Room Size")
                            .font(.headline)
                    }
                    
                    HStack(spacing: 12) {
                        ForEach(RoomSize.allCases, id: \.self) { size in
                            RoomSizeCard(
                                size: size,
                                isSelected: viewModel.designInput.roomSize == size
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    viewModel.designInput.roomSize = size
                                }
                            }
                        }
                    }
                }
                
                // Lighting Preference
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(.yellow)
                        Text("Lighting Preference")
                            .font(.headline)
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(LightingType.allCases, id: \.self) { lighting in
                            LightingCard(
                                lighting: lighting,
                                isSelected: viewModel.designInput.lightingPreference == lighting
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    viewModel.designInput.lightingPreference = lighting
                                }
                            }
                        }
                    }
                }
                
                // Furniture Style
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "chair.fill")
                            .foregroundStyle(.brown)
                        Text("Furniture Style")
                            .font(.headline)
                    }
                    
                    Picker("Furniture Style", selection: $viewModel.designInput.furnitureStyle) {
                        ForEach(FurnitureStyle.allCases, id: \.self) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
                
                // Generate Button
                Button {
                    viewModel.generateDesign()
                } label: {
                    HStack {
                        if viewModel.isGenerating {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.white)
                        } else {
                            Image(systemName: "wand.and.stars")
                        }
                        Text(viewModel.isGenerating ? "Creating Design..." : "Generate Design")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: RoundedRectangle(cornerRadius: 16)
                    )
                }
                .disabled(!viewModel.canGenerateDesign || viewModel.isGenerating)
                .opacity(viewModel.canGenerateDesign ? 1.0 : 0.6)
                .padding(.top, 10)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Supporting Views
struct RoomTypeCard: View {
    let roomType: RoomType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: roomType.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : .blue)
                
                Text(roomType.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .blue : .white)
            )
        }
        .buttonStyle(.plain)
    }
}

struct StyleCard: View {
    let style: DesignStyle
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(style.rawValue)
                    .font(.headline)
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Text(style.description)
                    .font(.caption)
                    .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 200, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .purple : .white)
            )
        }
        .buttonStyle(.plain)
    }
}

struct RoomSizeCard: View {
    let size: RoomSize
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(size.rawValue)
                    .font(.headline)
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Text(size.dimensions)
                    .font(.caption)
                    .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .indigo : .white)
            )
        }
        .buttonStyle(.plain)
    }
}

struct LightingCard: View {
    let lighting: LightingType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: lighting.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : .yellow)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lighting.rawValue)
                        .font(.headline)
                        .foregroundStyle(isSelected ? .white : .primary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .yellow : .white)
            )
        }
        .buttonStyle(.plain)
    }
} 
