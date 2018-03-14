//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Graphical

class MyViewController : UIViewController {
    
    let label = UILabel()
    var creationTask:VideoCreationTask?
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createVideo()
        super.viewDidAppear(animated)
    }
    
    func createVideo(){
        setupCreationTask()
        
//        creationTask!.createVideo(done: { (results) in
//            switch results {
//                case .failure(let error): break
//                case .success(let url): break
//                case .progress(let percentDone, let message): break
//        }
//        })
    }
    
    func setupPixelBuffer(){
        
    }
    
    func setupCreationTask(){
        let layer = view.layer
        creationTask = VideoCreationTask(layer: layer)
        do {
            try creationTask?.prepareForWriting()
        }catch VideoCreationError.failedWriter {
            print("Failed writer")
        }catch {
            print(error)
        }
        creationTask?.startWriting()
    }
    
    
    func didFail(error:VideoCreationError){
        
    }
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
