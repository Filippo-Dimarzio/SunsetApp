import SwiftUI
import PhotosUI

struct PhotoCaptureView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var snapManager: SunsetSnapManager
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()

                Button("Post Sunset Snap") {
                    snapManager.savePhoto(image: image)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            } else {
                PhotosPicker("Select Sunset Photo", selection: $photoSelection, matching: .images)
                    .padding()
            }
        }
    }

    @State private var photoSelection: PhotosPickerItem? {
        didSet {
            Task {
                if let data = try? await photoSelection?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
    }
}

