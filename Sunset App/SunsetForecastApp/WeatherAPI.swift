import Foundation
import CoreLocation

struct WeatherResponse: Codable {
    struct Clouds: Codable { let all: Int }
    struct Main: Codable { let humidity: Int }
    struct Visibility: Codable { let value: Int? } // visibility in meters, sometimes optional
    
    let clouds: Clouds
    let main: Main
    let visibility: Int? // in meters
}

class WeatherService: ObservableObject {
    @Published var clouds: Int? = nil
    @Published var humidity: Int? = nil
    @Published var visibility: Int? = nil // kilometers
    @Published var errorMessage: String? = nil

    private let apiKey = "e94cf7dd7ceea30ce33c2ba5a022bcdc"

    func fetchWeather(for location: CLLocationCoordinate2D) {
        errorMessage = nil
        clouds = nil
        humidity = nil
        visibility = nil

        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid weather URL"
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Weather network error: \(error.localizedDescription)"
                }
                return
            }
            guard let data = data,
                  let result = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse weather data"
                }
                return
            }

            DispatchQueue.main.async {
                self.clouds = result.clouds.all
                self.humidity = result.main.humidity
                if let vis = result.visibility {
                    self.visibility = vis / 1000 // convert meters to km
                } else {
                    self.visibility = nil
                }
            }
        }.resume()
    }
}
