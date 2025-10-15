//
//  CameraViewController.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 24/09/25.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    private var captureSession: AVCaptureSession!
    private var photoOutput: AVCapturePhotoOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    var onPhotoCaptured: ((UIImage) -> Void)?
    
    private let sessionQueue = DispatchQueue(label: "session queue")
    
    private var isSessionConfigured = false

    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermissionAndSetupSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sessionQueue.async {
            if self.isSessionConfigured && self.captureSession?.isRunning == false {
                self.captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async {
            if self.isSessionConfigured && self.captureSession?.isRunning == true {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func takePhoto() {
        sessionQueue.async {
            guard self.captureSession.isRunning else {
                return
            }
            let settings = AVCapturePhotoSettings()
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
    
    private func checkCameraPermissionAndSetupSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupSession()
                }
            }
        default:
            print("Access denid")
        }
    }
    
    private func setupSession() {
        sessionQueue.async {
            guard !self.isSessionConfigured else { return }
            
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            
            self.captureSession.sessionPreset = .photo
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                  self.captureSession.canAddInput(videoDeviceInput) else {
                self.captureSession.commitConfiguration()
                return
            }
            self.captureSession.addInput(videoDeviceInput)
            
            self.photoOutput = AVCapturePhotoOutput()
            guard self.captureSession.canAddOutput(self.photoOutput) else {
                self.captureSession.commitConfiguration()
                return
            }
            self.captureSession.addOutput(self.photoOutput)
            
            self.captureSession.commitConfiguration()
            self.isSessionConfigured = true
            
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
        }
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
        
        if let error = error {
            print("Error to show image \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            return
        }
        
        DispatchQueue.main.async {
            self.onPhotoCaptured?(image)
        }
    }
}

