## InteriorDesigner — AI Interior Design Suggestions (iOS, SwiftUI)

### Overview
InteriorDesigner is an iOS SwiftUI app that helps users plan and visualize room interiors with AI‑assisted suggestions. Users can describe their room, choose styles, and receive layout ideas, color palettes, and furniture recommendations. The app is structured with the MVVM (Model–View–ViewModel) pattern for a clean separation of concerns and testability.

### Key Features
- **AI suggestions**: Generate design ideas from a short room description and selected style.
- **Layouts and zoning**: Get suggested furniture placement and traffic flow hints.
- **Color palettes**: Curated palettes per style and room type.
- **Furniture recommendations**: Style‑consistent pieces with approximate dimensions.
- **Moodboards**: Quick moodboard preview combining colors and hero items.
- **Save and share**: Bookmark ideas and share snapshots with friends or clients.
- **Offline first (graceful)**: Caches the latest successful suggestion set for quick re‑viewing.

Note: Depending on your setup, AI suggestions can be powered by an external API or a local stub for development.

### Architecture: MVVM
- **Models (`Models/`)**: Plain data types that represent domain entities (e.g., `Room`, `DesignStyle`, `Palette`, `SuggestionSet`).
- **ViewModels (`ViewModels/`)**: Business logic and state. They expose observable properties to the views and orchestrate calls to services (AI, persistence, etc.).
- **Views (`Views/`)**: SwiftUI views that render the UI based on data from the ViewModels. Views are kept declarative and as logic‑free as possible.
- **Services (optional)**: Abstractions for AI provider, persistence, and analytics. Recommended folders: `Services/AI`, `Services/Persistence`.

This separation makes it easy to test ViewModels without UI, swap AI providers, and keep Views simple and reusable.

### Project Structure
```
InteriorDesigner/
  ├─ InteriorDesignerApp.swift
  ├─ Models/
  ├─ ViewModels/
  └─ Views/
```

### Data Flow (High Level)
1. User enters a prompt and selects a style in a `View`.
2. The `ViewModel` validates input and calls an AI service.
3. The AI service returns structured suggestions (layout, palette, items).
4. The `ViewModel` transforms results into view state and persists a cache.
5. `Views` render updated state; user can save, regenerate, or share.

### Tech Stack
- **Language/UI**: Swift, SwiftUI, Combine
- **AI**: Pluggable provider (HTTP API) or local stub for development
- **Storage**: On‑device cache (UserDefaults/FileCache) or Core Data (optional)

### Getting Started
1. Open the Xcode project in this directory.
2. Select a simulator or device running iOS 17+.
3. Build and run.

### Configuration (AI Provider)
If you use a live AI provider:
- Add an API key securely via an `.xcconfig` file or environment‑based configuration.
- Recommended: Create `Configs/Secrets.xcconfig` (not committed) with a line like `AI_API_KEY = YOUR_KEY` and reference it from the project’s build settings.
- In your AI service implementation, read the key from the build configuration or Keychain.

### Testing
- Unit‑test ViewModels by injecting a mock AI service and verifying state transitions.
- Prefer snapshot tests for complex SwiftUI views (optional).

### Accessibility
- Use Dynamic Type, VoiceOver labels, and sufficient contrast in palettes.
- Prefer SF Symbols or vector assets for clarity across sizes.

### Future Improvements
- **AR preview**: Place suggested items in a room with ARKit/RealityKit.
- **Photo input**: Analyze a photo of the room to tailor suggestions.
- **On‑device ML**: Core ML fine‑tuned models for faster, private inference.
- **Budgeting**: Cost breakdowns and alternative picks per budget.
- **Vendor integration**: Deep links to purchase or view availability.
- **Multi‑room planning**: Projects that span multiple rooms and shared styles.
- **Collaboration**: Shareable boards and feedback annotations.
- **Localization**: Multi‑language support and region‑specific catalogs.

### License
Add a license of your choice (e.g., MIT) to clarify usage.


