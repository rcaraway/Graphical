//: Playground - noun: a place where people can play

import UIKit
import ImageIO
import Graphical
import PlaygroundSupport

extension UIImage {
    
    func imageSource() -> CGImageSource? {
        guard let data:NSData = UIImagePNGRepresentation(self) as NSData? else {
            return nil
        }
        let bytes = data.bytes.assumingMemoryBound(to: UInt8.self)
        guard let cfData = CFDataCreate(kCFAllocatorDefault, bytes, data.length) else {return nil}
        let source = CGImageSourceCreateWithData(cfData, nil)
        return source
    }
}

extension CGImageSource {
    
    func image() -> UIImage?{
        guard let image = CGImageSourceCreateImageAtIndex(self, 0, nil) else {
            return nil
        }
        return UIImage(cgImage: image)
    }
    
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.backgroundColor = .yellow

let image = view.layer.image()

let imageView = UIImageView(frame: view.bounds)
imageView.image = image

let source = image?.imageSource()?.image()
print(source)
imageView.image = source

PlaygroundPage.current.liveView = imageView









