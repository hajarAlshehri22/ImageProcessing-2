import SwiftUI
import PhotosUI

// MARK: Making extension to call image Color Picker
extension View {
    func imageColorPicker(showPicker: Binding<Bool>, color: Binding<Color>, imageData: Binding<Data>, colorSelected: @escaping (Color) -> Void) -> some View {
        return self
            .fullScreenCover(isPresented: showPicker) {
                Helper(showPicker: showPicker, color: color, colorSelected: colorSelected)
            }
    }
}

// MARK: Custom view for Color Picker
struct Helper: View {
    @Binding var showPicker: Bool
    @Binding var color: Color
    @State private var pickedColors: [Color] = []

    // This assumes the rectangle is full width and the picker is 100x50
    // The y-position is set to 25 to vertically center the picker within the 50-height rectangle
    @State private var pickerPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.midX - 1, y: 30)
    var colorSelected: (Color) -> Void // Add this callback
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(color)
                    .frame(width: 50, height: 50) // Height of the rectangle
                    .padding(.trailing)
                    .padding(.bottom)
                // Custom color picker, which we want to center
                CustomColorPicker(color: $color, pickerPosition: $pickerPosition)
                    .frame(width: 100, height: 50)
                    .position(pickerPosition)

            }
            .frame(maxWidth: .infinity) // This makes the rectangle full width

            // Display picked colors
            HStack {
                ForEach(pickedColors, id: \.self) { color in
                    Rectangle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                }
            }
            .padding()

            // Add color to picked colors array
            Button("Add Color") {
                           colorSelected(color)
                       }
                       .padding()
        }
        .navigationBarTitle("Image Color Picker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Close") {
                showPicker = false
            }
        }
    }
}

// MARK: Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var showPicker: Bool
    @Binding var imageData: Data
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let first = results.first {
                first.itemProvider.loadObject(ofClass: UIImage.self) { result, err in
                    guard let image = result as? UIImage else {
                        self.parent.showPicker.toggle()
                        return
                    }
                    self.parent.imageData = image.jpegData(compressionQuality: 1) ?? Data()
                    self.parent.showPicker.toggle()
                }
            } else {
                parent.showPicker.toggle()
            }
        }
    }
}

// MARK: Custom Color Picker with the help of UIColorPickerViewController
struct CustomColorPicker: UIViewControllerRepresentable {
    @Binding var color: Color
    @Binding var pickerPosition: CGPoint

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.selectedColor = UIColor(color)
        picker.delegate = context.coordinator
        picker.title = ""
        return picker
    }

    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
    }

    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        var parent: CustomColorPicker

        init(parent: CustomColorPicker) {
            self.parent = parent
        }

        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            parent.color = Color(viewController.selectedColor)
            // Adjust the picker position after color selection
            parent.pickerPosition = CGPoint(x: parent.pickerPosition.x + 60, y: parent.pickerPosition.y)
        }

        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            parent.color = Color(color)
        }
    }
}


