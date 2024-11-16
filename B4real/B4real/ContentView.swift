//
//  ContentView.swift
//  B4real
//
//  Created by thaclaw on 11/15/24.
//

import SwiftUI
import PhotosUI
import ParseSwift

struct ContentView: View {
    @State private var showPicker = false
    @State private var selectedImage: UIImage?
    @State private var caption: String = ""
    @State private var uploadMessage: String = ""

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }

            TextField("Caption", text: $caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Select Photo") {
                showPicker = true
            }
            .padding()

            Button("Upload Photo") {
                if let image = selectedImage {
                    uploadPhoto(image: image, caption: caption)
                }
            }
            .padding()

            Text(uploadMessage)
                .foregroundColor(.green)
                .padding()
        }
        .sheet(isPresented: $showPicker) {
            PhotoPicker(selectedImage: $selectedImage)
        }
    }

    func uploadPhoto(image: UIImage, caption: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let file = ParseFile(name: "image.jpg", data: imageData)
        var post = Post()
        post.image = file
        post.caption = caption
        post.user = User.current

        post.save { result in
            switch result {
            case .success:
                uploadMessage = "Photo uploaded successfully!"
            case .failure(let error):
                uploadMessage = "Upload failed: \(error.localizedDescription)"
            }
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

