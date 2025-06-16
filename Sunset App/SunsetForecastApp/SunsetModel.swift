// Defines Codable structs for decoding JSON from the sunset API.

import Foundation

struct SunsetResults: Codable {
    let sunset: String
    let sunrise: String
}

struct SunsetResponse: Codable {
    let results: SunsetResults
    let status: String
}