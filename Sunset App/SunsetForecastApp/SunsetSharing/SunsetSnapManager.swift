import Foundation
import SwiftUI

class SunsetSnapManager: ObservableObject {
    @Published var photoEntries: [PhotoEntry] = []

    private let saveKey = "sunsetPhotoEntries"

    init() {
        loadPhotos()
    }

    func savePhoto(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)

        do {
            try data.write(to: url)
            let entry = PhotoEntry(imagePath: filename)
            photoEntries.append(entry)
            savePhotos()
        } catch {
            print("Error saving image: \(error)")
        }
    }

    func loadPhotos() {
        guard let savedData = UserDefaults.standard.data(forKey: saveKey) else { return }
        do {
            let entries = try JSONDecoder().decode([PhotoEntry].self, from: savedData)
            photoEntries = entries.sorted(by: { $0.date > $1.date })
        } catch {
            print("Error loading saved photos: \(error)")
        }
    }

    func savePhotos() {
        do {
            let data = try JSONEncoder().encode(photoEntries)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Error saving photo entries: \(error)")
        }
    }

    func image(for entry: PhotoEntry) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(entry.imagePath)
        return UIImage(contentsOfFile: url.path)
    }

    func hasPostedToday() -> Bool {
        if let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) {
            return photoEntries.contains(where: {
                Calendar.current.isDate($0.date, inSameDayAs: today)
            })
        }
        return false
    }
}


 
