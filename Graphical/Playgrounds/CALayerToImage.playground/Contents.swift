import UIKit
import PlaygroundSupport
import Graphical

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
            var img = self.image()
            DispatchQueue.main.async {
                done(img)
            }
        }
    }
    
    public func imageWithoutSubviews() -> UIImage? {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = backgroundColor
        return layer.image()
    }
    
    
}




let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
view.backgroundColor = .white

let subview = UIView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
subview.backgroundColor = .yellow

let label = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 30))
label.text = "Money"


view.addSubview(label)
view.addSubview(subview)

view.layer.getImage { (img) in
    print(img)
}

let createdLayer = CALayer()
createdLayer.frame = view.bounds
createdLayer.backgroundColor = UIColor.black.cgColor

let image = view.layer.imageWithoutSubviews()
let imageView:UIImageView = UIImageView(frame: view.bounds)
imageView.image = image
PlaygroundPage.current.liveView = imageView


