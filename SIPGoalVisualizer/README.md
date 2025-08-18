# 🚀 SIP Goal Visualizer - AI-Powered Stock Investment Platform

A revolutionary FinTech app that combines traditional SIP (Systematic Investment Plan) goal tracking with AI-powered stock recommendations to help users achieve their financial goals faster through intelligent investment strategies.

## ✨ Key Features


https://github.com/user-attachments/assets/2ccc71f7-41c4-4310-9b76-005e3bb29090



### 🎯 **Goal Management**
- Create and track multiple financial goals (House, Car, Education, Retirement, etc.)
- Visual progress tracking with beautiful animated circular progress bars
- Real-time goal completion estimates with compound interest calculations
- Category-based goal organization with custom icons and gradients
- Goal filtering and search functionality

### 📈 **Stock Market Integration**
- Real-time stock data from Indian markets (BSE) via API integration
- Live price updates, market trends, and technical indicators
- Stock filtering by risk level, performance, and value
- Comprehensive stock analysis with 52-week highs/lows, volume, and ratings
- Pull-to-refresh functionality for latest market data

### 🤖 **AI-Powered Stock Recommendations**
- **Foundation Model Integration**: LLM-based intelligent stock recommendations
- **Goal-Specific Matching**: AI analyzes your goals and suggests optimal stocks
- **Compound Interest Logic**: Advanced calculations for time-to-goal optimization
- **Confidence Scoring**: AI provides confidence levels and detailed reasoning
- **Investment Strategy**: Personalized investment plans with quantity suggestions

### 💡 **Smart Investment Features**
- **Stock Comparison Tool**: Side-by-side comparison of AI-recommended stocks
- **Investment Calculator**: Real-time calculation of investment impact on goals
- **Time-to-Goal Optimization**: AI suggests stocks that help achieve goals fastest
- **Risk Assessment**: Comprehensive risk analysis with color-coded indicators
- **Portfolio Management**: Track all stock investments with goal associations

### 🎨 **Beautiful UI/UX**
- Modern, animated interface with smooth spring animations
- Interactive charts, progress visualizations, and gradient backgrounds
- Responsive design with haptic feedback and loading states
- Intuitive navigation with tab-based interface
- Empty states and error handling with user-friendly messages

## 🏗️ Technical Architecture

### **Frontend (SwiftUI)**
- **MVVM Pattern**: Clean architecture with separation of concerns
- **Combine Framework**: Reactive programming for data binding and state management
- **Custom Animations**: Spring animations, pulse effects, and smooth transitions
- **Shared Components**: Reusable UI components for consistency

### **Backend Services**
- **Stock API Integration**: `https://stock.indianapi.in/BSE_most_active` with authentication
- **LLM Service**: AI-powered recommendation engine with compound interest calculations
- **Data Models**: Comprehensive stock, investment, and recommendation models
- **Error Handling**: Robust error handling with fallback mechanisms

### **Key Components**

#### **Models**
- `Goal`: Financial goal with progress tracking and category classification
- `Stock`: Complete stock data with technical indicators and market metrics
- `StockInvestment`: Investment tracking with goal associations
- `StockRecommendation`: AI recommendation with confidence and reasoning
- `StockComparison`: Side-by-side stock comparison with winner selection
- `UserPreferences`: Investment preferences and risk tolerance

#### **Services**
- `StockService`: Handles API calls, authentication, and data processing
- `LLMService`: Manages AI recommendations with compound interest calculations
- `GoalsViewModel`: Central business logic and data management

#### **Views**
- `DashboardView`: Main overview with progress, stats, and stock portfolio
- `StockMarketView`: Stock browsing with filtering and search
- `StockRecommendationsView`: AI-powered recommendations with loading animations
- `StockDetailView`: Detailed stock analysis with investment calculator
- `StockComparisonView`: Side-by-side stock comparison with winner selection
- `InvestmentConfirmationView`: Complete investment flow with goal impact
- `AddGoalView`: Goal creation with form validation and clearing

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation
1. Clone the repository
2. Open `SIPGoalVisualizer.xcodeproj` in Xcode
3. Build and run the project
4. The app will automatically fetch stock data and load sample goals

### API Integration
The app integrates with the Indian stock market API:
- **Endpoint**: `https://stock.indianapi.in/BSE_most_active`
- **Authentication**: API key authentication with `x-api-key` header
- **Data Format**: JSON with comprehensive stock information
- **Real-time Updates**: Automatic data refresh with loading states


## 🔧 Development Setup

### **Code Organization**
```
SIPGoalVisualizer/
├── Models/
│   ├── Goal.swift
│   └── Stock.swift
├── ViewModels/
│   └── GoalsViewModel.swift
├── Views/
│   ├── DashboardView.swift
│   ├── StockMarketView.swift
│   ├── StockRecommendationsView.swift
│   ├── StockDetailView.swift
│   ├── StockComparisonView.swift
│   ├── InvestmentConfirmationView.swift
│   ├── AddGoalView.swift
│   └── GoalsListView.swift
├── Services/
│   ├── StockService.swift
│   └── LLMService.swift
├── Utils/
│   ├── AnimationUtils.swift
│   └── SharedUIComponents.swift
└── Assets/
    └── Assets.xcassets
```

### **Dependencies**
- **SwiftUI**: Native iOS UI framework with declarative syntax
- **Combine**: Reactive programming for data binding and state management
- **Foundation**: Core iOS functionality and data structures
- **Network**: API communication with URLSession


## 📞 Contact & Support

This project demonstrates advanced iOS development skills, AI integration, FinTech innovation, and user experience design. Perfect for showcasing to potential employers in the FinTech space!

---

**Built with ❤️ using SwiftUI, AI-powered insights, and compound interest optimization for smarter financial planning! 🚀📈** 
