//
//  VideoPixelBuffer.swift
//  Graphical
//
//  Created by Rob Caraway on 3/14/18.
//  Copyright © 2018 Rob Caraway. All rights reserved.
//

import UIKit
import CoreVideo
import CoreGraphics
import ImageIO
import MobileCoreServices


public protocol BufferTask {
    
    func generateBufferFrame(done: @escaping (CVPixelBuffer?) -> Void)
    
}

public struct BlankVideoBufferTask: BufferTask {
    
    public init() {
    }
    
    public func generateBufferFrame(done: @escaping (CVPixelBuffer?) -> Void) {
        VideoSingleFrameGenerator.createSingleFrame(customizations: { (context, frame) in
            context.setFillColor(UIColor.white.cgColor)
            print("fillin")
            context.fill(frame)
        }) { (buffer) in
            print("done fill")
            done(buffer)
        }
    }

}
