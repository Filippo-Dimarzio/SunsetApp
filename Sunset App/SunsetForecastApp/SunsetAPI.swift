// Handles API call to fetch sunset/sunrise times.
// Uses user's location and updates UI via @Published.


import Foundation
import CoreLocation

class SunsetService: ObservableObject {
    @Published var sunsetTime: String = "Loading..."
    @Published var sunriseTime: String = "Loading..."

    func fetchSunset(for location: CLLocationCoordinate2D) {
        let urlString = "https://api.sunrise-sunset.org/json?lat=\(location.latitude)&lng=\(location.longitude)&formatted=0"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,
                  let result = try? JSONDecoder().decode(SunsetResponse.self, from: data) else {
                DispatchQueue.main.async {
                    self.sunsetTime = "Error"
                    self.sunriseTime = "Error"
                }
                return
            }

            DispatchQueue.main.async {
                self.sunsetTime = String(result.results.sunset.prefix(16)).replacingOccurrences(of: "T", with: " ")
                self.sunriseTime = String(result.results.sunrise.prefix(16)).replacingOccurrences(of: "T", with: " ")
            }
        }.resume()
    }
}

struct SunsetResponse: Codable {
    struct Results: Codable {
        let sunrise: String
        let sunset: String
    }
    let results: Results
    let status: String
}

class SunsetService: ObservableObject {
    @Published var sunsetTime: String = "Loading..."
    @Published var sunriseTime: String = "Loading..."
    @Published var errorMessage: String? = nil

    func fetchSunset(for location: CLLocationCoordinate2D) {
        errorMessage = nil
        let urlString = "https://api.sunrise-sunset.org/json?lat=\(location.latitude)&lng=\(location.longitude)&formatted=0"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.sunsetTime = "Error"
                self.sunriseTime = "Error"
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    self.sunsetTime = "Error"
                    self.sunriseTime = "Error"
                }
                return
            }
            guard let data = data,
                  let result = try? JSONDecoder().decode(SunsetResponse.self, from: data),
                  result.status == "OK" else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse sunset data"
                    self.sunsetTime = "Error"
                    self.sunriseTime = "Error"
                }
                return
            }

            DispatchQueue.main.async {
                self.sunsetTime = String(result.results.sunset.prefix(16)).replacingOccurrences(of: "T", with: " ")
                self.sunriseTime = String(result.results.sunrise.prefix(16)).replacingOccurrences(of: "T", with: " ")
            }
        }.resume()
    }
}