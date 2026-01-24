# 🏡 Real Estate App - Premium Property Discovery Platform

A sophisticated iOS real estate application that revolutionizes the property search experience with immersive video tours, interactive floor plans, advanced filtering, and beautiful animations. Built with SwiftUI, this app provides a seamless and engaging way to explore and discover premium properties.

## ✨ Key Features

### 🏠 **Property Browsing & Discovery**
- Clean, modern card-based property listings
- Scrollable property feed with detailed information
- Property cards displaying key metrics (bedrooms, bathrooms, square footage)
- Beautiful image previews with smooth transitions

### 🎬 **Immersive Video Tours**
- Full-screen property video tours with slow-motion playback (0.25x speed)
- Custom video player with AVKit integration
- Interactive video controls with sheet-based details

### 🔍 **Advanced Filtering System**
- **Bedroom Filter**: Any, 1, 2, 3, or 4+ bedrooms
- **Bathroom Filter**: Any, 1, 2, 3, or 4+ bathrooms
- **Price Range Slider**: $300 - $12,000 with visual distribution graph
- **Price Distribution Graph**: Bell-curve visualization of property prices

### 📊 **Interactive Floor Plans**
- Multi-floor navigation with swipeable cards
- Detailed floor plan images with full-screen view
- **Interactive Hotspots**: Blinking hotspot animations on floor plans
- **Video Integration**: Each floor has associated video tour
- Floor-by-floor video walkthroughs

### 📈 **Price Estimation Analytics**
- **Animated Line Graphs**: Smooth 3-second drawing animation
- **4-Year Price History**: Historical price trends (2020-2024)
- **Price Trend Visualization**: Gradient-filled area charts
- **Dynamic Calculations**: Randomized realistic price variations
- **Viewport-based Animation**: Charts animate when scrolled into view
- **Min/Max Price Tracking**: Automatic range calculations

## 🏗️ Technical Architecture

### **Frontend (SwiftUI)**
- **MVVM Architecture**: Clean separation of concerns with ViewModels
- **ObservableObject Pattern**: Reactive state management with @Published properties
- **Combine Framework**: Asynchronous event handling and data binding
- **GeometryReader**: Precise layout calculations for responsive design
- **Namespace Animations**: Smooth transitions between views
- **AVKit Integration**: Professional video playback capabilities

### **Project Structure**
```
Real State App/
├── Models/
│   └── PropertyModel.swift
│       - PropertyModel: Complete property data structure
│       - FloorModel: Floor plan and video associations
│       - Sample data: Pre-configured property listings
├── ViewModels/
│   └── homePageViewModal.swift
│       - HomePageViewModel: Central business logic
│       - Filter management and application
│       - Dynamic property calculations
├── Views/
│   ├── Home/
│   │   ├── HomePageView.swift
│   │   ├── FilterSheetView.swift
│   │   └── Components/
│   │       ├── PropertyCardView.swift
│   │       ├── PropertyPriceSlider.swift
│   │       ├── SlidingSegmentedControlView.swift
│   │       ├── FloatingSnackbar.swift
│   │       └── BottomNavBar.swift
│   ├── PropertyDetail/
│   │   ├── PropertyDetailView.swift
│   │   ├── PropertyDetailSheetView.swift
│   │   └── Components/
│   │       ├── FloorDetailView.swift
│   │       ├── FloorPlanCard.swift
│   │       ├── FullscreenFloorPlanView.swift
│   │       ├── PriceLineGraphView.swift
│   │       └── BlinkingHotspot.swift
│   └── components/
│       ├── CustomVideoPlayerView.swift
│       └── GlossyButton.swift
├── Extensions/
│   └── Color.swift
└── Resources/
    ├── Fonts/
    │   ├── europa-grotesk-medium.ttf
    │   ├── Helvetica Now Display Bold.ttf
    │   └── Helvetica Now Display Medium.ttf
    ├── Assets.xcassets/
    │   ├── Property images (real state 1-3)
    │   ├── Floor plans (plan1-3)
    │   └── Videos (property tours)
    └── Videos/
        ├── real state 1.mp4
        └── interior.mp4
```

## 📱 User Experience Flow

1. **Launch**: Opens to property feed with profile header
2. **Browse**: Scroll through property cards with images and details
3. **Filter**: Tap filter icon to open comprehensive filtering sheet
4. **Refine**: Select bedrooms, bathrooms, price range, and options
5. **Apply**: See filtered results with snackbar confirmation
6. **View Details**: Tap property card for full-screen video tour
7. **Explore**: Drag sheet up for detailed information and floor plans
8. **Floor Plans**: View interactive floor plans with hotspot markers
9. **Video Tours**: Watch floor-by-floor video walkthroughs
10. **Price Analysis**: Review historical price trends and estimates


## 📞 Contact & Support

This project demonstrates advanced iOS development expertise including video integration, complex animations, sophisticated filtering systems, and modern SwiftUI design patterns. Perfect for showcasing real-world app development skills in the real estate and property tech domain!

---

**Built with ❤️ using SwiftUI, AVKit, advanced animations, and modern iOS design principles! 🏡✨**
