//
//  UIImage+Extensions.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 24/09/25.
//

import UIKit

extension UIImage {
    
    func toPixelBuffer(size: CGSize) -> CVPixelBuffer? {
            let attrs = [
                kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
            ] as CFDictionary
            
            var pixelBuffer: CVPixelBuffer?
            let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                             Int(size.width),
                                             Int(size.height),
                                             kCVPixelFormatType_32ARGB,
                                             attrs,
                                             &pixelBuffer)
            
            guard status == kCVReturnSuccess, let unwrappedPixelBuffer = pixelBuffer else {
                return nil
            }
            
            CVPixelBufferLockBaseAddress(unwrappedPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(unwrappedPixelBuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            guard let context = CGContext(data: pixelData,
                                          width: Int(size.width),
                                          height: Int(size.height),
                                          bitsPerComponent: 8,
                                          bytesPerRow: CVPixelBufferGetBytesPerRow(unwrappedPixelBuffer),
                                          space: rgbColorSpace,
                                          bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                return nil
            }
            
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            
            UIGraphicsPushContext(context)
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            UIGraphicsPopContext()
            
            CVPixelBufferUnlockBaseAddress(unwrappedPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            
            return unwrappedPixelBuffer
        }
    
}
