import SwiftUI

    struct ContentView: View {
        @State private var image: UIImage? = nil
        @State private var showImagePicker = false
        @State private var showConvertedView = false
        @State private var showColorPicker = false
        @State private var convertedImage: UIImage? = nil
        @State private var pickedColor: Color = .white
        @State private var imageData: Data = Data()
        @State private var isProcessing = false
        @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
        @State private var showingActionSheet = false
        @State private var selectedColors: [Color] = [] // Add this line to store selected colors

        var body: some View {
            NavigationView {
                VStack {
               // This view will handle displaying the placeholder or the selected image
           ImagePlaceholder(image: image)
              .onTapGesture {
                showingActionSheet = true
                                 }
                    // Display selected colors under the image
                                    HStack {
                                        ForEach(selectedColors, id: \.self) { color in
                                            Rectangle()
                                                .fill(color)
                                                .frame(width: 30, height: 30)
                                        }
                                    }
                    
                             if let uiImage = image, let imageData = uiImage.jpegData(compressionQuality: 1.0) {
                                 if !showColorPicker {
                                     // Only show the "Pick Color" button if the color picker is not already shown
                                     Button("Pick Color") {
                                         self.imageData = imageData
                                         showColorPicker = true
                                     }
                                     .padding()

                                     // Display Convert Button conditionally
                                     // Modify ConvertButton to pass selected colors
                                                     ConvertButton {
                                                         isProcessing = true
                                                         convertImage(image: uiImage, colors: selectedColors)
                                                     }
                                 } else {
                                     Helper(showPicker: $showColorPicker, color: $pickedColor) { selectedColor in
                                         self.selectedColors.append(selectedColor)
                                     }
                                     .frame(height: 150)  // Set the height you want for the color picker
                                   .padding()
                                 }
                             }

                             Spacer()
                }
                .navigationBarTitle("")
                .navigationBarItems(leading: EmptyView(), trailing: LogoImageView()) // Set your custom logo image view as the trailing navigation bar item
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Select Image"), buttons: [
                        .default(Text("Camera")) {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                sourceType = .camera
                                showImagePicker = true
                            }
                        },
                        .default(Text("Photo Gallery")) {
                            sourceType = .photoLibrary
                            showImagePicker = true
                        },
                        .cancel()
                    ])
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(image: $image, sourceType: sourceType)
                }
                .sheet(isPresented: $showConvertedView) {
                    if let convertedImage = convertedImage {
                        ConvertedImageView(image: convertedImage, selectedColors: selectedColors) // Pass the selectedColors here
                    }
                }
            }
        }

        func convertImage(image: UIImage, colors: [Color]) {
                // Modify this function to use selected colors
                DispatchQueue.global(qos: .userInitiated).async {
                    let processedImage = ImageProcessing.convertImageToOutline(image, withColors: colors)
                    DispatchQueue.main.async {
                        convertedImage = processedImage
                        showConvertedView = true
                        isProcessing = false
                    }
                }
            }
    
}
struct LogoImageView: View {
    var body: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
    }
}

struct ImagePlaceholder: View {
    let image: UIImage?

    var body: some View {
       
        
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 350, maxHeight: 350)
                .border(Color.gray, width: 1)
        } else {
            Spacer()
            Text("Start saving your moments by")
             .font(.headline)
              .foregroundColor(.gray)
               Text("uploading / taking a picture")
                .font(.headline)
                 .foregroundColor(.gray)
            DashedRectangle()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(width: 350, height: 350)
                .foregroundColor(.gray)
                .overlay(
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 28))
                            .foregroundColor(.gray)
                        Text("Tap to upload")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                )
        }
    }
}

struct ConvertButton: View {
    let action: () -> Void

    var body: some View {
        Button("Convert", action: action)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("mycolor"))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}



struct DashedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: 8, height: 8))
        return path
    }
}

struct ConvertedImageView: View {
    let image: UIImage
    let selectedColors: [Color] // Add this line to store selected colors

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .navigationTitle("Converted Image")

            // Display selected colors under the converted image
            HStack {
                ForEach(selectedColors, id: \.self) { color in
                    Rectangle()
                        .fill(color)
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

