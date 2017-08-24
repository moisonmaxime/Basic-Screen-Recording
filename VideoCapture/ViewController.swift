//
//  ViewController.swift
//  VideoCapture
//
//  Created by Maxime Moison on 8/23/17.
//  Copyright © 2017 Maxime Moison. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    @IBOutlet weak var button: NSButton!
    var previewLayer : AVCaptureVideoPreviewLayer?
    var session : AVCaptureSession?
    var output: AVCaptureMovieFileOutput?
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
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            input = try AVCaptureDeviceInput(device: device)
        } catch {
            print("Error")
        }
        
        
        if (input != nil) {
            session?.removeInput(session?.inputs.first as! AVCaptureInput)
            session?.addInput(input)
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
                previewLayer = AVCaptureVideoPreviewLayer(session: session)
                
                previewLayer?.frame = customView.bounds
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
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
}

