//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Graphical
import CoreImage

class MyViewController : UIViewController {
    
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .black

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .white
        
        view.addSubview(label)
        self.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupPixelBuffer()
        super.viewDidAppear(animated)
    }
    
    func setupPixelBuffer(){
        print("buffer")
        let bufferTask = BlankVideoBufferTask.init()
        bufferTask.generateBufferFrame { (buffer) in
            print(buffer)
            self.setupImageView(buffer: buffer!)
            
        }
        
    }
    
    func setupImageView(buffer:CVPixelBuffer){
        let ciImage = CIImage.init(cvPixelBuffer: buffer)
        let context = CIContext(options: nil)
        if let videoImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer))) {
            let image = UIImage(cgImage: videoImage)
            print(image)
            
            let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 320, height: 320))
            imageView.image = image
            view.addSubview(imageView)
        }
    }
    
}

PlaygroundPage.current.liveView = MyViewController()
