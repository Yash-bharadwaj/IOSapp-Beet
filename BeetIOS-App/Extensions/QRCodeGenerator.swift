import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

extension View {
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return nil
    }
}

struct QRCodeView: View {
    let data: String
    @State private var qrImage: UIImage?
    
    var body: some View {
        Group {
            if let qrImage = qrImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .onAppear {
                        generateQRCode()
                    }
            }
        }
    }
    
    private func generateQRCode() {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            
            let data = Data(self.data.utf8)
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledImage = outputImage.transformed(by: transform)
                
                if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                    let uiImage = UIImage(cgImage: cgImage)
                    DispatchQueue.main.async {
                        self.qrImage = uiImage
                    }
                }
            }
        }
    }
}

