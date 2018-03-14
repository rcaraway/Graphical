//
//  VideoCreationTask.swift
//  Graphical
//
//  Created by Robert Caraway on 3/1/18.
//  Copyright © 2018 Rob Caraway. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo


public enum VideoCreationError: Error {
    case invalidLayer
    case failedWriter
    case failedStart
    case conversionFailed
}

public typealias ProgressPercentDone = Double
public typealias ProgressMessage = String
public typealias VideoCreationProgress = (ProgressPercentDone, ProgressMessage)

public enum VideoCreationResult {
    case success(URL)
    case failure(VideoCreationError)
    case progress(VideoCreationProgress)
}

public typealias VideoCreationBlock = (VideoCreationResult) -> Void



public class VideoCreationTask: NSObject {

    
    public private(set) var videoLayer:CALayer
    public private(set) var assetWriter:AVAssetWriter?
    public private(set) var writerInput:AVAssetWriterInput?
    public private(set) var assetAdaptor:AVAssetWriterInputPixelBufferAdaptor?
    public private(set) var tempPath:URL?

    
    //MARK: initialization
    public init(layer: CALayer) {
        videoLayer = layer
        super.init()
    }
    
    public func prepareForWriting() throws {
        let moviePath = String.temporaryMovieFilePath()
        tempPath = URL(fileURLWithPath: moviePath)
        guard let writer = standardWriter() else {
            let error = VideoCreationError.failedWriter
            print(error)
            throw error
        }
        assetWriter = writer
        writerInput = standardInput()
        assetAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput!, sourcePixelBufferAttributes: nil)
    }
    
    public func startWriting(){
        guard let writer = assetWriter,
            let input = writerInput else {
                let error = VideoCreationError.failedStart
                print("Failed to get writer and input")
                return
        }
        if (writer.canAdd(input)) {
            writer.add(input)
        }else{
            let error = VideoCreationError.failedStart
            print("failed to add input")
        }
        if !writer.startWriting() {
            let error = VideoCreationError.failedStart
            print(writer.error)
            print("failed to start writing")
            return
        }
        writer.startSession(atSourceTime: kCMTimeZero)
        print("began writing")
    }
    
    
    public func createVideo(done: @escaping VideoCreationBlock) {
        
        DispatchQueue.global().async {
            
            //Create an image source from the layer
            guard let imageSource = self.videoLayer.image()?.imageSource() else {
                let error = VideoCreationError.invalidLayer
                DispatchQueue.main.async {
                    done(.failure(error))
                }
                return
            }
         
            //TODO: return buffer attributes
           guard let writer = self.assetWriter,
            let input = self.writerInput,
            let adaptor = self.assetAdaptor else {
                fatalError()
            }
            
            let i = 0
            let fps = 60
            let seconds = 3
            let totalFrames = fps * seconds
            let queue = DispatchQueue(label: "VideoCreation")
            input.requestMediaDataWhenReady(on: queue, using: {
                while (input.isReadyForMoreMediaData){
                    
                    if (i >= (totalFrames)){
                        input.markAsFinished()
                        writer.endSession(atSourceTime: CMTime.init(value: CMTimeValue(totalFrames), timescale: CMTimeScale(fps)))
                        break
                    }
                    
                    if (input.isReadyForMoreMediaData){
                        
                    }
                    
                }
                
                //need an FPS
                //need a duration
            })
        }
    }


    //MARK: end Session
    
    private func endSession(){
        
    }

    //MARK: Convenience
    
    private func standardWriter() -> AVAssetWriter?{
        assert(tempPath != nil)
        let writer = try? AVAssetWriter(url: tempPath!, fileType: AVFileType.mov)
        return writer
    }
    
    private func standardInput() -> AVAssetWriterInput {
        
        let settings = [AVVideoCodecKey:AVVideoCodecType.h264,
                        AVVideoWidthKey:NSNumber(value:640),
                        AVVideoHeightKey:NSNumber(value:640)] as [String : Any]
        
        let input = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: settings)
        input.naturalSize = CGSize(width: 640, height: 640)
        return input
    }
    
}
