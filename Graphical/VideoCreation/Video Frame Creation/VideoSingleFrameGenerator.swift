//
//  VideoSingleFrameGenerator.swift
//  Graphical
//
//  Created by Rob Caraway on 3/14/18.
//  Copyright © 2018 Rob Caraway. All rights reserved.
//

import UIKit
import CoreGraphics
import ImageIO
import CoreVideo
import MobileCoreServices

public struct VideoSingleFrameGenerator {

    
    public static func createSingleFrame(customizations: @escaping (CGContext, CGRect) -> Void, done: @escaping (CVPixelBuffer?) -> Void ){
        var pixelBuffer:CVPixelBuffer?
        let pixelOptions = standardImageOptions()
        let imagframe = imageRect()
        CVPixelBufferCreate(kCFAllocatorDefault,
                            Int(imagframe.size.width),
                            Int(imagframe.size.height),
                            kCVPixelFormatType_32ARGB, pixelOptions, &pixelBuffer)
        
        assert(pixelBuffer != nil, "Failed to create pixel Buffer")
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        assert(pixelData != nil, "Failed to create pixel data")
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context:CGContext = CGContext(data: pixelData, width: Int(imagframe.size.width), height: Int(imagframe.size.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(imagframe.size.width), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            print("Failed to create context for image buffer")
            return
        }
        
        customizations(context, imagframe)
        
        
        
        defer {
            if pixelBuffer != nil {
                CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            }
        }
        done(pixelBuffer)
        
    }
    
    private static func standardImageOptions() -> CFDictionary {
        return [kCGImageSourceTypeIdentifierHint : kUTTypePNG] as CFDictionary
    }
    
    private static func standardPixelOptions() -> CFDictionary {
        return [kCVPixelBufferCGImageCompatibilityKey: true,
                kCVPixelBufferCGBitmapContextCompatibilityKey: true,
                kCVPixelBufferWidthKey: 640,
                kCVPixelBufferHeightKey: 640] as CFDictionary
    }
    
    private static func imageRect() -> CGRect {
        return CGRect.init(x: 0, y: 0, width: 640, height: 640)
    }
}
