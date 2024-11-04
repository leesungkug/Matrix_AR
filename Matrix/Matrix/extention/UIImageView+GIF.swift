//
//  UIImageView+GIF.swift
//  Matrix
//
//  Created by sungkug_apple_developer_ac on 11/4/24.
//

import UIKit
import ImageIO

extension UIImageView {
    func loadGIF(name: String) {
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: name, ofType: "gif"),
               let data = NSData(contentsOfFile: path),
               let source = CGImageSourceCreateWithData(data, nil) {
                
                var images = [UIImage]()
                var duration: Double = 0
                
                for i in 0..<CGImageSourceGetCount(source) {
                    if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                        let frameDuration = UIImageView.frameDuration(at: i, source: source)
                        duration += frameDuration
                        images.append(UIImage(cgImage: cgImage))
                    }
                }
                
                DispatchQueue.main.async {
                    self.animationImages = images
                    self.animationDuration = duration / 0.5
                    self.startAnimating()
                }
            }
        }
    }
    
    private static func frameDuration(at index: Int, source: CGImageSource) -> Double {
        let frameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any]
        let gifProperties = frameProperties?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
        
        let delayTime = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double
            ?? gifProperties?[kCGImagePropertyGIFDelayTime as String] as? Double
        ?? 0.1
        
        return delayTime
    }
}
