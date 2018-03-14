//
//  UIImage+IO.swift
//  Graphical
//
//  Created by Robert Caraway on 3/1/18.
//  Copyright © 2018 Rob Caraway. All rights reserved.
//

import Foundation

public extension UIImage {
    
    public func imageSource() -> CGImageSource? {
        guard let data:NSData = UIImagePNGRepresentation(self) as NSData? else {
            return nil
        }
        let bytes = data.bytes.assumingMemoryBound(to: UInt8.self)
        guard let cfData = CFDataCreate(kCFAllocatorDefault, bytes, data.length) else {return nil}
        let source = CGImageSourceCreateWithData(cfData, nil)
        return source
    }
    
}

public extension CGImageSource {
    
    public func image() -> UIImage?{
        guard let image = CGImageSourceCreateImageAtIndex(self, 0, nil) else {
            return nil
        }
        return UIImage(cgImage: image)
    }
    
}
