import Foundation
import CoreLocation
import Combine

// Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocationCoordinate2D? = nil
    @Published var permissionDenied = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            permissionDenied = true
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
}

// Sunset API Service
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

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocationCoordinate2D? = nil
    @Published var permissionDenied = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            permissionDenied = false
        case .denied, .restricted:
            permissionDenied = true
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
}