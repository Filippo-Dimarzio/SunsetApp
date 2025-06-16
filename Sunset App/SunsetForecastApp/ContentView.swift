import SwiftUI
import CoreLocation


struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var sunsetService = SunsetService()
    @StateObject private var weatherService = WeatherService()
    @StateObject private var snapManager = SunsetSnapManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Sunset Forecast")
                        .font(.largeTitle)
                        .bold()

                    // Show user location
                    if let loc = locationManager.currentLocation {
                        Text("Location: \(loc.latitude.formatted()), \(loc.longitude.formatted())")
                    } else {
                        Text("Locating...")
                    }

                    // Sunrise/sunset times
                    VStack {
                        Text("Sunrise: \(sunsetService.sunriseTime)")
                        Text("Sunset: \(sunsetService.sunsetTime)")
                    }
                    .padding()

                    // Sunset error
                    if let error = sunsetService.errorMessage {
                        Text("Sunset API Error: \(error)").foregroundColor(.red)
                    }

                    // Weather info & sunset quality
                    VStack {
                        if let clouds = weatherService.clouds,
                           let humidity = weatherService.humidity,
                           let visibility = weatherService.visibility {
                            Text("Clouds: \(clouds)%")
                            Text("Humidity: \(humidity)%")
                            Text("Visibility: \(visibility) km")

                            Text("Sunset Quality: \(SunsetLogic.calculateSunsetScore(clouds: clouds, humidity: humidity, visibility: visibility))")
                                .font(.title2)
                                .bold()
                        } else if let weatherError = weatherService.errorMessage {
                            Text("Weather API Error: \(weatherError)").foregroundColor(.red)
                        } else {
                            Text("Loading weather data...")
                        }
                    }
                    .padding()

                    // Refresh Button
                    Button("Refresh") {
                        if let location = locationManager.currentLocation {
                            sunsetService.fetchSunset(for: location)
                            weatherService.fetchWeather(for: location)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .foregroundColor(.white)
                    .clipShape(Capsule())

                    // Location permission error
                    if locationManager.permissionDenied {
                        Text("Location permission denied. Please enable it in settings.")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }

                    // --- Sunset Sharing Feature ---
                    Divider().padding(.top)

                    NavigationLink("📸 Take Sunset Photo") {
                        PhotoCaptureView(snapManager: snapManager)
                    }
                    .padding()

                    NavigationLink("🖼️ View Sunset Gallery") {
                        PhotoGalleryView(snapManager: snapManager)
                    }
                    .padding(.bottom)
                }
                .padding()
            }
            .navigationBarTitle("Sunset App", displayMode: .inline)
        }
        .onAppear {
            if let location = locationManager.currentLocation {
                sunsetService.fetchSunset(for: location)
                weatherService.fetchWeather(for: location)
            }
        }
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let location = newLocation {
                sunsetService.fetchSunset(for: location)
                weatherService.fetchWeather(for: location)
            }
        }
    }
}

