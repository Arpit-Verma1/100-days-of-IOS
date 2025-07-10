# CryptoNest 📱💰

A modern, feature-rich cryptocurrency tracking iOS app built with SwiftUI that provides real-time market data, portfolio management, and detailed coin analytics.

![CryptoNest App](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0+-orange.svg)
![Swift](https://img.shields.io/badge/Swift-5.0+-red.svg)

## 🚀 Features

### 📊 **Live Market Data**
- Real-time cryptocurrency prices from CoinGecko API
- Top 250 cryptocurrencies by market cap
- 24-hour price change tracking with visual indicators
- Market statistics (Market Cap, Volume, BTC Dominance)

### 💼 **Portfolio Management**
- Add/remove cryptocurrencies to personal portfolio
- Track holdings and current portfolio value
- Real-time portfolio performance calculation
- Portfolio value percentage change tracking

### 📈 **Interactive Charts**
- 7-day price sparkline charts for each coin
- Animated chart rendering with smooth transitions
- Color-coded charts (green for gains, red for losses)
- Responsive chart scaling and formatting

### 🔍 **Advanced Search & Filtering**
- Real-time search functionality across coin names, symbols, and IDs
- Multiple sorting options (Rank, Price, Holdings)
- Debounced search with 0.5-second delay for optimal performance
- Smooth transitions between filtered results

### 📱 **Detail Views**
- Comprehensive coin information and statistics
- Expandable coin descriptions
- Additional details (ATH, ATL, supply information)
- Direct links to official websites and Reddit communities

### 🎨 **Modern UI/UX**
- Dark theme with custom color palette
- Smooth animations and transitions
- Haptic feedback for user interactions
- Responsive design for all iOS devices
- Custom animated buttons and components

## 🏗️ Architecture

### **MVVM Pattern**
The app follows the Model-View-ViewModel (MVVM) architecture pattern:

- **Models**: `CoinModel`, `MarketDataModel`, `StatisticModel`
- **Views**: SwiftUI views for UI components
- **ViewModels**: `HomeViewModel`, `DetailViewModel` for business logic

### **Service Layer**
- **CoinDataService**: Handles cryptocurrency data fetching
- **MarketDataService**: Manages global market statistics
- **PortfolioDataService**: Core Data integration for portfolio persistence
- **NetworkManager**: Generic networking layer with error handling

### **Data Flow**
```
API (CoinGecko) → Services → ViewModels → Views
                     ↓
                Core Data (Portfolio)
```

## 🛠️ Technical Implementation

### **Networking**
- **Combine Framework**: Reactive programming for data streams
- **URLSession**: Custom networking layer with retry logic
- **Error Handling**: Comprehensive error management with custom error types
- **Data Decoding**: JSON decoding with custom CodingKeys

### **Data Persistence**
- **Core Data**: Local storage for portfolio data
- **PortfolioEntity**: Managed object for user holdings
- **CRUD Operations**: Add, update, and delete portfolio entries

### **UI Components**
- **Custom Extensions**: Color themes, number formatting, date handling
- **Reusable Components**: CircleButton, CoinImageView, StatisticView
- **Animations**: Spring animations, linear transitions, custom keyframes

### **Performance Optimizations**
- **Debounced Search**: Prevents excessive API calls
- **Lazy Loading**: Efficient list rendering
- **Memory Management**: Proper use of weak references
- **Background Processing**: Async data fetching

## 📁 Project Structure

```
CryptoNest/
├── Core/
│   ├── Components/          # Reusable UI components
│   ├── Detail/             # Coin detail views
│   ├── Home/               # Main app views
│   ├── Launch/             # Launch screen
│   └── Settings/           # Settings views
├── Models/                 # Data models
├── Services/               # API and data services
├── Utilities/              # Helper classes
└── Extensions/             # Swift extensions
```

## 🎯 Key Features Implementation

### **Real-time Data Updates**
```swift
// Combine publishers for reactive data flow
$searchText.combineLatest(coinDataService.$allCoins, $sortOption)
    .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
    .map(filterAndSortCoins)
    .sink { [weak self] (returnedCoins) in
        self?.AllCoins = returnedCoins
    }
```

### **Portfolio Management**
```swift
// Core Data integration for portfolio persistence
func updatePortfolio(coin: CoinModel, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
}
```

### **Animated Charts**
```swift
// Custom chart rendering with animations
Path { path in
    for index in data.indices {
        let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index+1)
        let yPosition = calculateYPosition(data[index])
        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
    }
}
.trim(from: 0, to: percentage)
.stroke(lineColor, style: StrokeStyle(lineWidth: 1))
```

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 15.0+
- Swift 5.0+

### Installation
1. Clone the repository
2. Open `CryptoNest.xcodeproj` in Xcode
3. Build and run the project

### API Configuration
The app uses the CoinGecko API for cryptocurrency data. No API key is required for basic usage.

## 🎨 Design System

### **Color Theme**
- **Accent Color**: Primary app color
- **Background Color**: Main background
- **Green/Red Colors**: For positive/negative price changes
- **Secondary Text**: For less prominent information

### **Typography**
- **Headlines**: Bold, prominent text for titles
- **Body Text**: Regular text for content
- **Captions**: Smaller text for secondary information

## 📱 User Experience

### **Navigation Flow**
1. **Launch Screen**: Animated app introduction
2. **Home View**: Toggle between Live Prices and Portfolio
3. **Search & Filter**: Find specific cryptocurrencies
4. **Detail View**: Comprehensive coin information
5. **Portfolio Management**: Add/edit holdings

### **Interactive Elements**
- **Haptic Feedback**: Tactile responses for actions
- **Smooth Animations**: Spring and ease transitions
- **Loading States**: Visual feedback during data fetching
- **Error Handling**: User-friendly error messages

## 🔧 Technical Challenges Solved

### **1. Real-time Data Synchronization**
- Implemented Combine publishers for reactive data flow
- Debounced search to prevent API rate limiting
- Efficient data filtering and sorting

### **2. Portfolio Performance Calculation**
- Real-time portfolio value updates
- Percentage change calculations
- Integration with Core Data for persistence

### **3. Custom Chart Implementation**
- Built custom chart rendering using SwiftUI Path
- Animated chart drawing with trim animations
- Responsive scaling for different screen sizes

### **4. Memory Management**
- Proper use of weak references in closures
- Efficient list rendering with LazyVStack
- Background processing for data fetching

## 🎯 Future Enhancements

- [ ] Push notifications for price alerts
- [ ] Watch app companion
- [ ] Advanced charting with multiple timeframes
- [ ] Social features and sharing
- [ ] Multiple currency support
- [ ] Offline mode with cached data

## 📄 License

This project is created for educational and portfolio purposes.

## 👨‍💻 About the Developer

**Arpit Verma** - iOS Developer passionate about creating intuitive and performant mobile applications. This project demonstrates expertise in:

- **SwiftUI** and modern iOS development
- **MVVM Architecture** and clean code principles
- **Combine Framework** for reactive programming
- **Core Data** for data persistence
- **Custom UI Components** and animations
- **API Integration** and networking
- **Performance Optimization** and best practices

---


https://github.com/user-attachments/assets/41217305-7690-4ece-8bd6-b7d874cbe526



*Built with ❤️ using SwiftUI and Combine* 
