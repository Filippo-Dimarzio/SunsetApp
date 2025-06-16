# 🌅 Sunset App Forecast

Sunset App Forecast is a SwiftUI-based iOS application that fetches and displays daily sunrise and sunset times using the user's location. It also calculates the quality of the sunset based on weather data and includes an interactive photo capture and gallery feature for sharing beautiful sunset moments.

## Features

- 📍 **Location-based Forecast**  
  Automatically fetches the user's current location to provide accurate sunrise and sunset times.

- ☁️ **Sunset Quality Scoring**  
  Uses cloud cover, humidity, and visibility data to generate a "Sunset Score" from 0 to 10.

- 🗓️ **Sunset History & Logging**  
  Displays past sunsets in a SwiftData-powered list, with support for editing and deleting.

- 📷 **Sunset Snap & Gallery**  
  Users can capture and view sunset photos through a built-in camera interface and gallery.

- 🔄 **Refresh Button**  
  Easily refresh all data (location, weather, and sunset) with one tap.

## Tech Stack

- **SwiftUI** for declarative UI
- **CoreLocation** for GPS data
- **URLSession & JSONDecoder** for REST API calls
- **SwiftData** for local data persistence
- **ObservableObject & @StateObject** for reactive data management
- **XCTest** for basic test coverage

## API Endpoints

- **Sunset/Sunrise Data**  
  `https://api.sunrise-sunset.org/json?lat={lat}&lng={lng}&formatted=0`

- **Weather Data** (Optional add-on)  
  Use an external weather API (e.g., OpenWeatherMap) with fields: clouds, humidity, and visibility

## How to Run

1. Open `SunsetAppForecast.xcodeproj` in **Xcode**
2. Ensure your deployment target is set to iOS 16.0+
3. Run on an iOS simulator or real device
4. Grant location permissions
5. Click “Refresh” to fetch latest sunset and weather data

## Screenshots

*(Add simulator screenshots or real photos here if available)*

## Requirements

- iOS 16+
- Swift 5.8+
- Xcode 15+

## Author

Filippo Di Marzio — [GitHub](https://github.com/Filippo-Dimarzio) | [LinkedIn](https://www.linkedin.com/in/filippo-di-marzio))



