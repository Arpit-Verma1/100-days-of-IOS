import SwiftUI

struct DesignResultView: View {
    @ObservedObject var viewModel: InteriorDesignViewModel
    @State private var selectedTab = 0
    @State private var showingColorPalette = false
    @State private var selectedFurnitureItem: FurnitureItem?
    @State private var showingFurnitureDetail = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if let design = viewModel.selectedDesign {
                        // Header with Design Info
                        DesignHeaderView(design: design)
                        
                        // Tab Navigation
                        CustomTabView(selectedTab: $selectedTab)
                        
                        // Tab Content
                        TabView(selection: $selectedTab) {
                            // Overview Tab
                            DesignOverviewTab(design: design)
                                .tag(0)
                            
                            // Furniture Tab
                            FurnitureTab(
                                design: design,
                                selectedItem: $selectedFurnitureItem,
                                showingDetail: $showingFurnitureDetail
                            )
                            .tag(1)
                            
                            // Lighting Tab
                            LightingTab(design: design)
                                .tag(2)
                            
                            // Accessories Tab
                            AccessoriesTab(design: design)
                                .tag(3)
                            
                            // Tips Tab
                            TipsTab(design: design)
                                .tag(4)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 600)
                    }
                }
            }
            .navigationTitle("Your Design")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        viewModel.showingResult = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New Design") {
                        viewModel.resetDesign()
                    }
                }
            }
        }
        .sheet(isPresented: $showingFurnitureDetail) {
            if let item = selectedFurnitureItem {
                FurnitureDetailView(item: item)
            }
        }
    }
}

// MARK: - Design Header
struct DesignHeaderView: View {
    let design: InteriorDesign
    @State private var showingColorPalette = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Design Name and Description
            VStack(spacing: 12) {
                Text(design.name)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                
                Text(design.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding(.horizontal, 20)
            
            // Color Palette Preview
            VStack(spacing: 12) {
                HStack {
                    Text("Color Palette")
                        .font(.headline)
                    Spacer()
                    Button("View All") {
                        showingColorPalette = true
                    }
                    .font(.caption)
                    .foregroundStyle(.blue)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(design.swiftUIColorPalette.prefix(5), id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(.quaternary, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 20)
            
            // Cost and Layout Preview
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("Estimated Cost")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(design.estimatedCost)
                        .font(.headline)
                        .foregroundStyle(.green)
                }
                
                Divider()
                
                VStack(spacing: 4) {
                    Text("Layout")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Optimized")
                        .font(.headline)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .sheet(isPresented: $showingColorPalette) {
            ColorPaletteDetailView(colors: design.swiftUIColorPalette)
        }
    }
}

// MARK: - Custom Tab View
struct CustomTabView: View {
    @Binding var selectedTab: Int
    
    private let tabs = ["Overview", "Furniture", "Lighting", "Accessories", "Tips"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                } label: {
                    Text(tabs[index])
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(selectedTab == index ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedTab == index ? .blue : .clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

// MARK: - Overview Tab
struct DesignOverviewTab: View {
    let design: InteriorDesign
    
    var body: some View {
        VStack(spacing: 20) {
            // Layout Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "square.grid.3x3")
                        .foregroundStyle(.blue)
                    Text("Layout Suggestions")
                        .font(.headline)
                }
                
                Text(design.layout)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 20)
            
            // Quick Stats
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                StatCard(title: "Furniture Items", value: "\(design.furniture.count)")
                StatCard(title: "Lighting Fixtures", value: "\(design.lighting.count)")
                StatCard(title: "Accessories", value: "\(design.accessories.count)")
                StatCard(title: "Color Palette", value: "\(design.colorPalette.count)")
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 20)
    }
}

// MARK: - Furniture Tab
struct FurnitureTab: View {
    let design: InteriorDesign
    @Binding var selectedItem: FurnitureItem?
    @Binding var showingDetail: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            LazyVStack(spacing: 12) {
                ForEach(design.furniture) { item in
                    FurnitureItemCard(item: item) {
                        selectedItem = item
                        showingDetail = true
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 20)
    }
}

// MARK: - Lighting Tab
struct LightingTab: View {
    let design: InteriorDesign
    
    var body: some View {
        VStack(spacing: 20) {
            LazyVStack(spacing: 12) {
                ForEach(design.lighting) { item in
                    LightingItemCard(item: item)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 20)
    }
}

// MARK: - Accessories Tab
struct AccessoriesTab: View {
    let design: InteriorDesign
    
    var body: some View {
        VStack(spacing: 20) {
            LazyVStack(spacing: 12) {
                ForEach(design.accessories) { item in
                    AccessoryItemCard(item: item)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 20)
    }
}

// MARK: - Tips Tab
struct TipsTab: View {
    let design: InteriorDesign
    
    var body: some View {
        VStack(spacing: 20) {
            LazyVStack(spacing: 12) {
                ForEach(Array(design.tips.enumerated()), id: \.offset) { index, tip in
                    TipCard(number: index + 1, tip: tip)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 20)
    }
}

// MARK: - Supporting Components
struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.blue)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct FurnitureItemCard: View {
    let item: FurnitureItem
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(item.type)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(item.placement)
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(item.priceRange)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                    
                    Text(item.material)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

struct LightingItemCard: View {
    let item: LightingItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.name)
                    .font(.headline)
                Spacer()
                Text(item.price)
                    .font(.caption)
                    .foregroundStyle(.green)
            }
            
            Text(item.type)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(item.placement)
                .font(.caption)
                .foregroundStyle(.blue)
            
            Text(item.effect)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct AccessoryItemCard: View {
    let item: AccessoryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.name)
                    .font(.headline)
                Spacer()
                Text(item.price)
                    .font(.caption)
                    .foregroundStyle(.green)
            }
            
            Text(item.type)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(item.placement)
                .font(.caption)
                .foregroundStyle(.blue)
            
            Text(item.styleNotes)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct TipCard: View {
    let number: Int
    let tip: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(.blue, in: Circle())
            
            Text(tip)
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Detail Views
struct FurnitureDetailView: View {
    let item: FurnitureItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        Text(item.name)
                            .font(.title.bold())
                        
                        Text(item.type)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        DetailRow(title: "Material", value: item.material)
                        DetailRow(title: "Price Range", value: item.priceRange)
                        DetailRow(title: "Placement", value: item.placement)
                        DetailRow(title: "Color", value: item.color)
                    }
                    .padding(20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
                .padding(20)
            }
            .navigationTitle("Furniture Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.body)
        }
    }
}

struct ColorPaletteDetailView: View {
    let colors: [Color]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ForEach(colors, id: \.self) { color in
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(color)
                                .frame(height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.quaternary, lineWidth: 1)
                                )
                            
                            Text(color.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(20)
                
                Spacer()
            }
            .navigationTitle("Color Palette")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 
