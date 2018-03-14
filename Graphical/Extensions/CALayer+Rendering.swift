//
//  CALayer+Rendering.swift
//  Graphical
//
//  Created by Robert Caraway on 3/1/18.
//  Copyright © 2018 Rob Caraway. All rights reserved.
//

import UIKit

public extension CALayer {
    
    public func image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size,
                                               isOpaque, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        var present = presentation()
        if present == nil {
            present = self
        }
        let pres:CALayer = present!
        pres.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public func getImage(done:@escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let img = self.image()
            DispatchQueue.main.async {
                done(img)
            }
        }
    }
    
    public func imageWithoutSublayers() -> UIImage? {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = backgroundColor
        return layer.image()
    }
    
}

