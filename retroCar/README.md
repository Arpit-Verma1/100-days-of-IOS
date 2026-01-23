# 🏎️ Retro Cars App - Classic Automotive Showcase

A beautifully designed iOS app that takes users on a nostalgic journey through iconic retro cars from the 1960s, 1970s, and 1980s. Experience classic automotive history with stunning animations, detailed specifications, and immersive video content.

## ✨ Key Features

https://github.com/user-attachments/assets/d889bca9-dcbd-4830-86d9-293c2a39709a

### 🎯 **Decade-Based Car Browsing**
- Interactive horizontal carousel showcasing cars from different eras
- Smooth scroll-based animations with dynamic card sizing
- Center-focused card scaling for enhanced visual hierarchy
- Snap-to-center scrolling behavior for precise navigation
- Era-specific color themes (1960s, 1970s, 1980s)

### 🎬 **Video Integration**
- Immersive intro video with custom circular expansion animation
- "VIEW STORY" interactive button with animated transitions
- Background video player with meter scale visualization
- Smooth video-to-content transitions with easing animations
- Full-screen video playback experience

### ✨ **Advanced Animations**
- **Hero Animations**: Seamless card-to-detail view transitions using Namespace
- **Scroll Animations**: Dynamic height scaling based on card position
- **Circular Expansion**: Custom circle-to-fullscreen animation effect
- **Spring Physics**: Natural, bouncy animations with proper damping
- **Opacity Transitions**: Smooth fade effects for UI elements

### 🚗 **Detailed Car Information**
- Comprehensive car specifications (model, code, tire size, wheel size)
- Classic car models including:
  - **1960s**: Chevrolet Corvette
  - **1970s**: Porsche 917K
  - **1980s**: BMW M1 PROCAR
- Technical details with traction control system descriptions
- Similar model comparisons and suggestions

## 🏗️ Technical Architecture

### **Frontend (SwiftUI)**
- **Modern SwiftUI Design**: Pure SwiftUI implementation with no UIKit dependencies
- **Declarative UI**: State-driven UI updates with @State and @Binding
- **Namespace Animations**: Advanced hero animations with matched geometry effects
- **GeometryReader**: Precise layout calculations for scroll-based animations
- **AVKit Integration**: Native video playback with AVPlayer

### **Project Structure**
```
retroCar/
├── Core/
│   ├── Home/
│   │   ├── View/
│   │   │   ├── HomeView.swift
│   │   │   └── VideoPlayerView.swift
│   │   └── Components/
│   │       └── YearCardView.swift
│   ├── YearDetail/
│   │   ├── View/
│   │   │   └── YearCardDetailView.swift
│   │   └── Components/
│   │       ├── BottomCardView.swift
│   │       ├── CarouselContainerView.swift
│   │       └── DetailRowView.swift
│   └── CarDetail/
│       ├── CarDetailView.swift
│       └── Components/
│           └── DropCappedTextView.swift
├── Models/
│   ├── CarModel.swift
│   ├── YearModel.swift
│   └── UserModal.swift
├── Extension/
│   └── Colors.swift
├── Resource/
│   ├── Assets.xcassets/
│   │   ├── 1960.imageset/
│   │   ├── 1970.imageset/
│   │   ├── 1980.imageset/
│   │   └── Colors/
│   └── Fonts/
│       ├── TuskerGrotesk-2800Super.ttf
│       ├── capital.ttf
│       ├── newston.otf
│       ├── RM Serifancy Regular.ttf
│       ├── rolf.otf
│       └── TuskerGrotesk-1500Medium.ttf
└── retroCarApp.swift
```

### **Key Components**

#### **Models**
- `CarModel`: Complete car specifications including company, model, tire size, and technical details
- `YearModel`: Decade representation with associated car, color theme, and user profile
- `UserModal`: User profile information with name and image

#### **Views**
- `HomeView`: Main carousel interface with scroll animations and video integration
- `VideoPlayerView`: Full-screen video player with custom entry/exit animations
- `YearCardView`: Individual decade card with hero animation support
- `YearCardDetailView`: Expanded view showing detailed car information and carousel
- `CarDetailView`: Comprehensive car specifications with drop-capped typography
- `BottomCardView`: Elegant specification cards with technical details
- `CarouselContainerView`: Swipeable image carousel for multiple car photos

#### **Custom Extensions**
- `Colors`: Theme color definitions for era-specific palettes
- Custom color hex initializer for precise color matching

## 📱 User Experience Flow

1. **Launch**: App opens to horizontal carousel of decade cards
2. **Browse**: Scroll through eras with dynamic size animations
3. **Story Mode**: Tap "VIEW STORY" for immersive video intro
4. **Details**: Tap any decade card for expanded view with hero animation
5. **Explore**: Swipe through car images in carousel
6. **Learn**: Read detailed specifications and technical information


## 📞 Contact & Support

This project demonstrates advanced SwiftUI skills including custom animations, video integration, scroll-based effects, and sophisticated UI/UX design. Perfect for showcasing iOS development expertise with a focus on visual polish and user experience!

---

**Built with ❤️ using SwiftUI, custom animations, and a passion for classic automotive design! 🏎️✨**
