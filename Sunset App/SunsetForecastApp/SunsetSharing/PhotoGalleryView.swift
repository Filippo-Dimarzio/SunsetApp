import SwiftUI

struct PhotoGalleryView: View {
    @ObservedObject var snapManager: SunsetSnapManager

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(snapManager.photoEntries) { entry in
                    if let image = snapManager.image(for: entry) {
                        VStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Sunset Gallery")
    }
}

