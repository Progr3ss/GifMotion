//
//  ViewController.swift
//  VideoFilter
//
//  Created by Martin Chibwe on 10/28/17.
//  Copyright © 2017 Martin Chibwe. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //An object that manages capture activity and coordinates the flow of data from input devices to capture outputs.
    let captureSession = AVCaptureSession()
    //A device that provides input (such as audio or video) for capture sessions and offers controls for hardware-specific capture features.
    var captureDevice: AVCaptureDevice?
    var captureDeviceInput: AVCaptureDeviceInput?
    //A Core Animation layer that can display video as it is being captured.
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    var videoFileOutput = AVCaptureVideoDataOutput()
    let videoDataOutput = AVCaptureVideoDataOutput()
//    let imageView = UIImageView(frame: CGRect.zero)
    var countSwipe = 0
    let FilterNames = [String](Filters.keys).sorted()
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraView: UIView!
    
    
    var assetWriter: AVAssetWriter?
    var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor?
    var isWriting = false
    var currentSampleTime: CMTime?
    var currentVideoDimensions: CMVideoDimensions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraPosition()
        startCameraSession()
    }
    
    
    func cameraPosition()   -> AVCaptureDevice{
        
        let availableCameraDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in availableCameraDevices as! [AVCaptureDevice] {
            if device.position == .back {
            
                captureDevice = device
            }
//            else if device.position == .front {
//
//                captureDevice = device
//            }
        }
        print("captureDevice \(String(describing: captureDevice))")
        return captureDevice!
        
    }
    
    
    func startCameraSession()  {
        //A constant value indicating the quality level or bitrate of the output.
        //Specifies capture settings suitable for high resolution photo quality output.
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        do {
            captureDeviceInput = try AVCaptureDeviceInput(device: cameraPosition())
            captureSession.addInput(captureDeviceInput)
            
        }catch{
            print("captureDeviceInput erorr: \(error)")
            return
        }
        
        // Configure the session with the output for capturing video
       videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
        
        // Configure the session with the input and the output devices
        if captureSession.canAddOutput(videoDataOutput)
        {
//            captureSession.addInput(captureDeviceInput)
            captureSession.addOutput(videoDataOutput)
            
            
            
        }
        
        // Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraView.layer.addSublayer(cameraPreviewLayer!)
        cameraView.bringSubview(toFront: imageView)
//        cameraView.addSubview(imageView)
//        cameraView.bringSubview(toFront: stackViewCamera)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = cameraView.layer.frame
        
        captureSession.startRunning()
        
        
    }
    
    func addFilters()  {
        
        
        
        
    }
    
    func swipeDirections()  {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.cameraView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.cameraView.addGestureRecognizer(swipeRight)

    }
    
    // COMMENT: This line makes sense - this is your pixelbuffer from the camera.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touched screen")
        swipeDirections()
    }
    
    func swipeAction(sender:UISwipeGestureRecognizer)  {
        
        switch sender.direction.rawValue {
        case 1:
            print("case 1 \(sender.direction.rawValue)")
            countSwipe += 1
            print("FilerNames \((FilterNames.count))")
        case 2:
            print("case 2 \(sender.direction.rawValue)")
            countSwipe -= 1
        default:
            break
        }
    }


}

extension ViewController:AVCaptureVideoDataOutputSampleBufferDelegate {
    
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
//        print("diddrop sample Buffer")
//        let FilterNames = [String](Filters.keys).sorted()
//
//        guard let filter = Filters[FilterNames[2]] else {
//            return
//        }
//
//        print("sampleBuffer \(sampleBuffer)")
//
//        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
//        if pixelBuffer != nil {
//            print("Not nil")
//        }else
//        {
//            print("found nil")
//        }
////        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
////        filter!.setValue(cameraImage, forKey: kCIInputImageKey)
////
////        let filteredImage = UIImage(ciImage: filter!.value(forKey: kCIOutputImageKey) as! CIImage!)
////
////        DispatchQueue.main.async
////            {
////                self.imageView.image = filteredImage
////        }
//    }
//
    
    
    func captureOutput(_ output: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        connection.videoOrientation = AVCaptureVideoOrientation.portrait
//        connection.videoOrientation = AVCaptureVideoOrientation.landscapeL
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("pixelBuffer error  ")
            return
            
        }
//        let select = Filters()
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer)
        let filter = CIFilter(name: CIFilterNames[countSwipe])!
//        let filter = Filters
        filter.setValue(cameraImage, forKey: kCIInputImageKey)
        
        let formateDescription = CMSampleBufferGetFormatDescription(sampleBuffer)!
        self.currentVideoDimensions = CMVideoFormatDescriptionGetDimensions(formateDescription)
        self.currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer)
        
        if self.isWriting {
            
            
            if self.assetWriterPixelBufferInput?.assetWriterInput.isReadyForMoreMediaData == true {
                var newPixelBuffer : CVPixelBuffer? = nil
                CVPixelBufferPoolCreatePixelBuffer(nil, self.assetWriterPixelBufferInput!.pixelBufferPool!, &newPixelBuffer)
                
                let success = self.assetWriterPixelBufferInput?.append(newPixelBuffer!, withPresentationTime: self.currentSampleTime!)
                
                if success == false{
                    print("Pixel Buffer failed")
                }
                
                
            }
        }
        
        
        DispatchQueue.main.async {
            
            if let outputValue = filter.value(forKey: kCIOutputImageKey) as? CIImage {
                let filteredImage = UIImage(ciImage: outputValue)
                self.imageView.image = filteredImage
            }
        }
        
        
        
        
    }
    
//    func captureOutput(_ output: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
////        print("disOutputSampleBuffer ")
////        let FilterNames = [String](Filters.keys).sorted()
//        //FilterNames.count-1]
////        guard let filter = Filters[FilterNames[countSwipe]] else {
////            return
////        }
//
//        let filter = CIFilterNames[1];
//
////        CIFilterNames.
////        guard let filter = CIFilterNames[1] else{
////            return
////        }
//
//        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
//
//        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
//
//
//        //Create filters for each button
//        let ciContext = CIContext(options:nil)
//        let coreImage = UIImage(ciImage: cameraImage)
//
////        print(coreImage)
////        let coreImage = CIImage(image: cameraImage)
//        let filtered = CIFilter(name: filter)
//        filtered!.setDefaults()
//        //filtered!.setValue(coreImage, forKey: kCIInputImageKey)
//        //let filteredImageData = filtered!.value(forKey: kCIOutputImageKey) as! UIImage
//        //let filteredImageRef =  ciContext.createCGImage(filteredImageData, from: filteredImageData.extent) as UIImage
//
//
////        let
//
////        let bloomFilter = CIFilter(name: CIFilterNames[1], withInputParameters: [kCIInputRadiusKey:0, kCIInputImageKey: cameraImage])!
////
////        let finalImage = bloomFilter.outputImage!
////        let image = UIImage(ciImage: finalImage)
//
//
////        filter.setValue(cameraImage, forKey: kCIInputImageKey)
////        let filteredImage = UIImage(ciImage: filter.value(forKey: kCIOutputImageKey) as! CIImage!)
//
//
//
////        let noirFilterOne = CIFilter(name: "CIPhotoEffectNoir", withInputParameters: [kCIInputImageKey: filteredImage])!
//
//        DispatchQueue.main.async
//        {
//
////            self.imageView.image = UIImage(cgImage: filteredImageRef!)
////            let noirFilterOne = CIFilter(name: "CIPhotoEffectNoir", withInputParameters: [kCIInputImageKey: self.imageView.image])!
//
////            self.imageView.image = image
//
//
//
////            self.imageView.image = filteredImage
////            image
////            self..image = filteredImage
////            self.imageView.image = filteredImage
////            self.sample
////            self.cameraView = filteredImage
//        }
//
//
////        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) != nil{
//
//
////        guard if pixelBuffer != nil {
////            return
////        }
//
////        }
////        if pixelBuffer != nil{
////            print("not nil")
////        }else{
////            print("found nil")
////            return
////        }
//    }
    
}

