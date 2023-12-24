import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ImageProcessing {
    static func convertImageToOutline(_ image: UIImage, withColors colors: [Color]) -> UIImage {
        // First, convert the image to an outline
        let outlinedImage = processImage(image)

        // Then, apply the selected colors to the outlined image
        return applyColorsToImage(outlinedImage, colors: colors)
    }
    
    private static func processImage(_ image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else {
            return image
        }
        
        // Apply Sobel edge detection filter
        let edgesFilter = CIFilter(name: "CIEdges")
        edgesFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        edgesFilter?.setValue(300.0, forKey: "inputIntensity")
        
        guard let edgesImage = edgesFilter?.outputImage else {
            return image
        }
        
        // Invert the edges
        let invertFilter = CIFilter(name: "CIColorInvert")
        invertFilter?.setValue(edgesImage, forKey: kCIInputImageKey)
        
        guard let invertedImage = invertFilter?.outputImage else {
            return image
        }
        
        // Convert to grayscale
        let grayscaleFilter = CIFilter(name: "CIColorControls")
        grayscaleFilter?.setValue(invertedImage, forKey: kCIInputImageKey)
        grayscaleFilter?.setValue(0.0, forKey: kCIInputSaturationKey)
        
        guard let highContrastImage = grayscaleFilter?.outputImage else {
            return image
        }
        
        // Adjust contrast
        let contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter?.setValue(highContrastImage, forKey: kCIInputImageKey)
        contrastFilter?.setValue(2.0, forKey: kCIInputContrastKey)
        
        guard let finalImage = contrastFilter?.outputImage else {
            return image
        }
        
        // Apply a blur
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(finalImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(1.0, forKey: kCIInputRadiusKey)
        
        guard let blurredImage = blurFilter?.outputImage else {
            return image
        }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(blurredImage, from: blurredImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }

    private static func applyColorsToImage(_ image: UIImage, colors: [Color]) -> UIImage {
        // Implement the logic to apply colors to the image
        // This is a placeholder for the actual implementation, which can be quite complex.
        // For now, it returns the original image without color modification.
        return image
    }
}
