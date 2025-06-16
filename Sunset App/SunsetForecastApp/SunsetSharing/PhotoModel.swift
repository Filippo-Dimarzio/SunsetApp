import Foundation

struct PhotoEntry: Identifiable, Codable {
    let id: UUID
    let imagePath: String
    let date: Date

    init(imagePath: String, date: Date = Date()) {
        self.id = UUID()
        self.imagePath = imagePath
        self.date = date
    }
}
