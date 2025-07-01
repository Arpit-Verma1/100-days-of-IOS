//
//  GradientGenerator.swift
//  ios_26
//
//  Created by Arpit Verma on 6/30/25.
//

import SwiftUI
import FoundationModels

struct GradientGenerator: View {
    @State private var isGeneratig : Bool = false
    @State private var generatigLimit : Int = 3
    @State private var userPrompt : String = ""
    @State private var isStopped : Bool = false
    @State private var pallates : [Pallete] = []
    @State private var selectedPallete: Pallete? = nil
    var body: some View {
        ZStack {
            if let selected = selectedPallete {
                LinearGradient(colors: selected.swiftUIColors, startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            } else {
                Color.clear.ignoresSafeArea()
            }
            VStack (alignment: .leading, spacing: 20) {
                Text("Gradient Generator")
                    .font(.largeTitle.bold())
                ScrollView(pallates.isEmpty ?  .vertical : .horizontal) {
                    HStack (spacing: 15) {
                        ForEach(pallates) { pallate in
                            VStack (spacing: 6) {
                                LinearGradient(colors: pallate.swiftUIColors, startPoint: .top, endPoint: .bottom)
                                    .clipShape(.circle)
                                Text(pallate.name)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                
                            }
                            .frame(maxHeight: .infinity)
                            .contentShape(.rect)
                            .onTapGesture {
                                selectedPallete = pallate
                            }
                            
                        }
                        if isGeneratig  || pallates.isEmpty {
                            VStack (spacing: 6) {
                                KeyframeAnimator(initialValue: 0.0, repeating: true) { rotation in
                                    Image(systemName: "apple.intelligence")
                                        .font(.largeTitle)
                                        .rotationEffect(.init(degrees: rotation))
                                } keyframes: { _ in
                                    LinearKeyframe(0, duration: 0)
                                    LinearKeyframe(360, duration: 5)
                                }
                                
                                if  pallates.isEmpty  {
                                    Text("Start crafting your gradient")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }

                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                    }.padding(15)
                }
                .frame(height: 100)
                .defaultScrollAnchor(.trailing,for : .sizeChanges)
                
                .disableOpacity(isGeneratig)
                
                TextField("Gradient Promt ", text: $userPrompt)
                    .padding(.horizontal, 15)
                    .padding(.vertical , 12)
                    .glassEffect()
                    .disableOpacity(isGeneratig)
                Stepper("Generation Limit: \(generatigLimit)", value: $generatigLimit,in: 1...10)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .glassEffect()
                    .disableOpacity(isGeneratig)
                
                Button {
                    if isGeneratig {
                        isStopped = true
                    }
                    else  {
                        generatePalletes()
                        isStopped = false
                    }
                    
                } label: {
                    Text(isGeneratig ? "Stop Crafting": "Create Gradient")
                        .contentTransition(.numericText())
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(.blue.gradient, in :.capsule)
                }
                .disableOpacity(userPrompt.isEmpty)
                
            }.safeAreaPadding(15)
                .glassEffect(.regular,in: .rect(cornerRadius: 15, style: .continuous))
        }
    }
    
    private func generatePalletes () {
        Task {
            do {
                isGeneratig = true
                let instruction : String  = """
                    Generate a smooth gradient color palette based on the user's prompt. The
                    gradient should transition between two or more colors relevant to
                    the theme, mood, or elements described in the prompt. Limit the
                    result to only \(generatigLimit) palettes.
                    """
                
                let session = LanguageModelSession  {
                    instruction
                }
                let  response = session.streamResponse(to: userPrompt, generating: [Pallete].self)
                
                for try await partialResult in response {
                    let palettes  = partialResult.compactMap {
                        if let id = $0.id,
                           let name = $0.name,
                           let colors = $0.colors?.compactMap({  $0 }),
                            
                            colors.count > 2 {
                            return Pallete(id: id, name: name, colors: colors)
    
                        }
                        return nil
                        
                    }
                    
                    
                    withAnimation(.snappy(duration: 0 , extraBounce: 0 )) {
                        self.pallates = palettes
                    }
                    
                    
                    if isStopped {
                        print("User - Stopped")
                        isGeneratig = false
                        return
                    }
                    
                }
                
                isGeneratig = false
                
            }
            catch {
                print(error.localizedDescription)
                isGeneratig = false
                isStopped = false
            }
        }
    }
}

//#Preview {
//    GradientGenerator()
//        .padding()
//}

@Generable

struct Pallete : Identifiable {
    var id: Int
    @Guide(description: "Gradient Name")
    var name : String
    @Guide(description: "Gradient Color")
    var colors : [String]
    var swiftUIColors : [Color] {
        colors.compactMap({
            .init(hex: $0)
        })
    }
}


extension View {
    func disableOpacity ( _ status : Bool ) -> some View  {
        self.disabled(status)
            .opacity(status ? 0.5 : 1)
    }
    
}


extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner (string: hexSanitized).scanHexInt64(&rgb)
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
