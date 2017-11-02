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

class ViewController: NSViewController, AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        return
    }
    
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
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            input = try AVCaptureDeviceInput(device: device!)
        } catch {
            print("Error")
        }
        
        
        if (input != nil) {
            session?.removeInput((session?.inputs.first)!)
            session?.addInput(input!)
            session?.startRunning()
        }
    }
    
    @IBAction func press(_ sender: Any) {
        
        if (session == nil || !(session?.isRunning)!) {
            session = AVCaptureSession.init()
            
            // print(CGMainDisplayID())
            let input = AVCaptureScreenInput.init(displayID: CGMainDisplayID())         // Screen Capture
            
            session?.addInput(input)
            previewLayer = AVCaptureVideoPreviewLayer(session: session!)
            
            let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self
            output = AVCaptureMovieFileOutput()
            
            self.session?.addOutput(output!)
            
            let documentsURL = FileManager.default.urls(for: .moviesDirectory, in: .userDomainMask)[0]
            let filePath = documentsURL.appendingPathComponent("temp.mp4")
            
            previewLayer?.frame = customView.bounds
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            customView.wantsLayer = true
            
            customView.layer?.addSublayer(previewLayer!)
            session?.startRunning()
            
            output?.startRecording(to: filePath as URL, recordingDelegate: recordingDelegate!)
            
            print("Capture started")
            button.title = "Stop"
            
        } else {
            previewLayer?.removeFromSuperlayer()
            output?.stopRecording()
            session?.stopRunning()
            print("Capture stopped")
            button.title = "Start"
        }
    }
    
}

