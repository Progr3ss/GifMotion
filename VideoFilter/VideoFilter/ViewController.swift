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
    
    @IBOutlet weak var cameraView: UIView!
    
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
            
        }catch{
            print("captureDeviceInput erorr: \(error)")
            return
        }
        
        // Configure the session with the output for capturing video
       videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
        
        // Configure the session with the input and the output devices
        if captureSession.canAddOutput(videoDataOutput)
        {
            captureSession.addInput(captureDeviceInput)
            captureSession.addOutput(videoDataOutput)
            
            
            
        }
        
        // Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraView.layer.addSublayer(cameraPreviewLayer!)
//        cameraView.bringSubview(toFront: stackViewCamera)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = cameraView.layer.frame
        
        captureSession.startRunning()
        
        
    }


}

extension ViewController:AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        print("diddrop sample Buffer")
    }
    
    
}

