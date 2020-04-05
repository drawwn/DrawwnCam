//
//  ViewController.swift
//  macOS Camera

import Cocoa
import AVFoundation
import Vision

class ViewController: NSViewController {

    // MARK: - Properties
    
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var videoSession: AVCaptureSession!
    fileprivate var cameraDevice: AVCaptureDevice!
    
    // MARK: - LyfeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.prepareCamera()
        self.startSession()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}


// MARK: - Prepare&Start&Stop camera

extension ViewController {
    
    func startSession() {
        if let videoSession = videoSession {
            if !videoSession.isRunning {
                videoSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if let videoSession = videoSession {
            if videoSession.isRunning {
                videoSession.stopRunning()
            }
        }
    }
    
    fileprivate func prepareCamera() {
        self.videoSession = AVCaptureSession()
        self.videoSession.sessionPreset = AVCaptureSession.Preset.photo
        self.previewLayer = AVCaptureVideoPreviewLayer(session: videoSession)
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Couldn't find camera")
            return
        }
                
        self.cameraDevice = device
        
        if cameraDevice != nil  {
            do {
                let input = try AVCaptureDeviceInput(device: cameraDevice)
                
                
                if videoSession.canAddInput(input) {
                    videoSession.addInput(input)
                }
                
                if let previewLayer = self.previewLayer {
                    if previewLayer.connection?.isVideoMirroringSupported ?? false {
                        previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
                        previewLayer.connection?.isVideoMirrored = true
                    }
                    
                    previewLayer.frame = self.view.bounds
                    view.layer = previewLayer
                    view.wantsLayer = true
                }
            } catch {
                print(error.localizedDescription)
            }
        }
                                            
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
        if videoSession.canAddOutput(videoOutput) {
            videoSession.addOutput(videoOutput)
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    internal func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        print(Date())
    }
}
