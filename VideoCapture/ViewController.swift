//
//  ViewController.swift
//  VideoCapture
//
//  Created by Maxime Moison on 8/23/17.
//  Copyright © 2017 Maxime Moison. All rights reserved.
//

import Cocoa
import AVFoundation
import CoreFoundation

class ViewController: NSViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var button: NSButton!
    var previewLayer : AVCaptureVideoPreviewLayer?
    var session : AVCaptureSession?
    var output: AVCaptureVideoDataOutput?
    @IBOutlet weak var customView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.title = "Start"
        self.view.wantsLayer = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        customView.layer?.backgroundColor = .black
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        previewLayer?.frame = customView.bounds
    }
    
    @IBAction func switchInputPress(_ sender: NSButton) {
        sender.isEnabled = false
        
        session?.stopRunning()
        var input:AVCaptureDeviceInput?                                             // Camera Capture
        
        do {
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            input = try AVCaptureDeviceInput(device: device!)
        } catch {
            print("Error")
        }
        
        
        if (input != nil) {
            session?.removeInput(session?.inputs.first as! AVCaptureInput)
            session?.addInput(input!)
            session?.startRunning()
        }
    }
    
    @IBAction func press(_ sender: Any) {
        
        if (session == nil || !(session?.isRunning)!) {
            session = AVCaptureSession.init()
            
            // print(CGMainDisplayID())
            let input = AVCaptureScreenInput.init(displayID: CGMainDisplayID())         // Screen Capture
            
            if (input != nil) {
                session?.addInput(input)
                previewLayer = AVCaptureVideoPreviewLayer(session: session!)
                
                output = AVCaptureVideoDataOutput.init()
                output?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : Int(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)]
                let captureSessionQueue = DispatchQueue(label: "CameraSessionQueue", attributes: [])
                output?.setSampleBufferDelegate(self, queue: captureSessionQueue)
                session?.addOutput(output!)
                
                previewLayer?.frame = customView.bounds
                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                customView.wantsLayer = true
                
                customView.layer?.addSublayer(previewLayer!)
                session?.startRunning()
                print("Capture started")
                button.title = "Stop"
                
            } else {
                print("Fail")
            }
        } else {
            previewLayer?.removeFromSuperlayer()
            session?.stopRunning()
            print("Capture stopped")
            button.title = "Start"
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        /// Do more fancy stuff with sampleBuffer.
        let imageBuffer:CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
    }
}

