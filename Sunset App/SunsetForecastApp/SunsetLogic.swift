// Simple logic to predict sunset quality based on weather values.


import Foundation

struct SunsetLogic {
    // Calculate sunset quality score and return a category string
    // Inputs: clouds (%), humidity (%), visibility (km)
    static func calculateSunsetScore(clouds: Int, humidity: Int, visibility: Int) -> String {
        // Simple weighted scoring example
        // Lower clouds + moderate humidity + good visibility => better sunset
        
        var score = 0
        
        // Clouds scoring (lower better)
        switch clouds {
        case 0...20:
            score += 3
        case 21...50:
            score += 2
        case 51...80:
            score += 1
        default:
            score += 0
        }
        
        // Humidity scoring (moderate humidity is best)
        switch humidity {
        case 30...60:
            score += 3
        case 20...29, 61...70:
            score += 2
        default:
            score += 1
        }
        
        // Visibility scoring (higher better)
        switch visibility {
        case 8...:
            score += 3
        case 5..<8:
            score += 2
        case 3..<5:
            score += 1
        default:
            score += 0
        }
        
        // Total max score = 9
        
        switch score {
        case 7...9:
            return "🔥 Vibrant Sunset"
        case 4...6:
            return "🌥️ Mild Sunset"
        default:
            return "😐 Not Ideal"
        }
    }
}

struct SunsetLogic {
    static func calculateSunsetScore(clouds: Int?, humidity: Int?, visibility: Int?) -> String {
        guard let clouds = clouds, let humidity = humidity, let visibility = visibility else {
            return "⚠️ Insufficient data"
        }
        
        var score = 0
        
        switch clouds {
        case 0...20: score += 3
        case 21...50: score += 2
        case 51...80: score += 1
        default: score += 0
        }
        
        switch humidity {
        case 30...60: score += 3
        case 20...29, 61...70: score += 2
        default: score += 1
        }
        
        switch visibility {
        case 8...: score += 3
        case 5..<8: score += 2
        case 3..<5: score += 1
        default: score += 0
        }
        
        switch score {
        case 7...9: return "🔥 Vibrant Sunset"
        case 4...6: return "🌥️ Mild Sunset"
        default: return "😐 Not Ideal"
        }
    }
}

