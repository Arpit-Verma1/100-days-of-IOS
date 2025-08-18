## 🏠 InteriorDesigner — On‑Device AI Interior Design (SwiftUI)

An iOS SwiftUI module that generates complete interior design plans on device using Apple’s Foundation Models. Users configure room parameters, watch an interactive “thinking” process with terminal‑style logs, and review structured, multi‑tab results including layout, furniture, lighting, accessories, tips, and color palettes.

## ✨ Key Features



https://github.com/user-attachments/assets/0c260e75-d2d0-429a-903c-d69eb1f7b579



### 🧩 Input & Configuration
- **Room Type**: `Living Room`, `Bedroom`, `Kitchen`, `Home Office`, `Dining Room`, `Bathroom`, `Nursery`, `Home Gym` (`RoomType`)
- **Design Style**: `Modern`, `Minimalist`, `Bohemian`, `Industrial`, `Scandinavian`, `Traditional`, `Coastal`, `Farmhouse` (`DesignStyle` with descriptions)
- **Color Mood Slider**: Warm ↔ Cool with dynamic label and tint
- **Budget Range**: `Budget`, `Mid‑Range`, `Luxury` with human‑readable ranges (`BudgetRange`)
- **Room Size**: `Small`, `Medium`, `Large` with dimension hints (`RoomSize`)
- **Lighting Preference**: `Natural`, `Ambient`, `Dramatic`, `Task` (`LightingType` with SF Symbol icons)
- **Furniture Style**: `Contemporary`, `Vintage`, `Rustic`, `Luxury`, `Eco‑Friendly` (`FurnitureStyle`)

### 🔄 Interactive Generation Flow
- **Stepwise Thinking UI** with progress and expandable steps (`ThinkingProcess`, `GenerationStep`)
- **Developer Terminal Logs** with levels: info, thinking, generating, success, error (`TerminalLog`)
- **Animated progress** and completion handoff to results view

### 📦 Structured AI Output (Strongly Typed)
- `InteriorDesign` with: name, description, colorPalette, furniture[], lighting[], accessories[], layout, estimatedCost, tips[]
- Item models: `FurnitureItem`, `LightingItem`, `AccessoryItem`
- Colors bridged to SwiftUI via `swiftUIColorPalette`

### 🧭 Results UI (Tabbed)
- **Overview**: Layout suggestions + quick stats
- **Furniture**: Tappable cards → detail sheet
- **Lighting**: Fixture list with placement/effect
- **Accessories**: Decor list with style notes
- **Tips**: Numbered practical advice

## 🏗️ Technical Architecture

### **Frontend (SwiftUI)**
- `InteriorDesignerApp.swift`: container view switching between input, process, and results
- `Views/InputFormView.swift`: all user inputs and the generate action
- `Views/GenerationProcessView.swift`: step timeline + terminal logs
- `Views/DesignResultView.swift`: multi‑tab result presentation and detail sheets

### **MVVM**
- **Model (`Models/InteriorDesign.swift`)**
  - Input types: `InteriorDesignInput`, `RoomType`, `DesignStyle`, `BudgetRange`, `RoomSize`, `LightingType`, `FurnitureStyle`
  - Output types: `InteriorDesign`, `FurnitureItem`, `LightingItem`, `AccessoryItem`
  - Process/log types: `ThinkingProcess`, `GenerationStep`, `TerminalLog`
- **ViewModel (`ViewModels/InteriorDesignViewModel.swift`)**
  - Published state: inputs, generated designs, selection, process/logs, UI flags (`isGenerating`, `showingResult`, `showingGenerationProcess`)
  - Validation: `canGenerateDesign`
  - Orchestration: `generateDesign()`, `selectDesign(_:)`, `resetDesign()`
- **Views (`Views/*.swift`)**
  - Declarative UI; minimal logic, rendering ViewModel state

### **On‑Device LLM (Apple Foundation Models)**
- Imports `FoundationModels`; uses `@Generable` + `@Guide` annotations for typed generation
- Streaming structured output via `LanguageModelSession` and `streamResponse(... generating: [InteriorDesign].self)`
- Partial results mapped into concrete models with init(from: PartiallyGenerated) extensions
- No network client present; generation occurs on device

## 🔧 Key Components

### **Models**
- `Models/InteriorDesign.swift`: Input enums/models; generated design models; thinking/log models; Color helpers

### **ViewModel**
- `ViewModels/InteriorDesignViewModel.swift`: Input management, logs, stepwise process, Apple FM session, streaming to `[InteriorDesign]`, selection, reset, memory cleanup

### **Views**
- `Views/InputFormView.swift`: All pickers/cards/slider + Generate button
- `Views/GenerationProcessView.swift`: Header progress, step list, collapsible terminal logs
- `Views/DesignResultView.swift`: Header with palette preview + tabs (Overview, Furniture, Lighting, Accessories, Tips) + detail sheets

## 🔁 Data Flow
1. User configures inputs in `InputFormView`
2. `InteriorDesignViewModel.generateDesign()` logs steps, updates `ThinkingProcess`, and starts an on‑device `LanguageModelSession`
3. Streaming partials are folded into typed `InteriorDesign` items and published
4. Upon completion, UI transitions from process → results and selects the first design
5. Tabs render the selected design; users can open detail sheets or start a new design

## 🚀 Getting Started
1. Open the project that includes this module
2. Use `InteriorDesignerApp()` as the entry view (or embed it where appropriate)
3. Build and run; configure inputs and tap “Generate Design”

## 📱 App Screens & Features
- **Input**: Room type, style, color mood slider, budget, size, lighting, furniture style
- **Generation**: Progress bar, thinking steps, animated terminal logs, cancel action
- **Results**: Palette preview, cost summary, layout text, tabbed details, furniture/lighting/accessory cards, tips list, detail sheets

## 🔮 Future Enhancements
- Persist generated designs locally and support favorites/history
- Export/share designs and color palettes
- Image/moodboard rendering from the generated structure
- Additional result visualizations (grids, comparisons)



