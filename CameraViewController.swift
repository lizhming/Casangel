//
//  CameraViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import AVFoundation
import UIKit
import Foundation

protocol CameraController {
    
    func prepare(completionHandler: @escaping (Error?) -> Void)
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void)
    
    func displayPreview(on view: UIView) throws
    
    func switchCameras() throws
    
}

class RealCameraController: NSObject, CameraController {
    
    var captureSession: AVCaptureSession?
    var currentCameraPosition: CameraPosition?
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInDualCamera],
                mediaType: AVMediaType.video,
                position: .unspecified)
            let cameras = (session.devices.compactMap { $0 })
            
            if (cameras.isEmpty) {
                throw CameraControllerError.noCamerasAvailable
            }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                } else if (camera.position == .back) {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }
            
            if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                if captureSession.canAddInput(self.frontCameraInput!) {
                    captureSession.addInput(self.frontCameraInput!)
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
                self.currentCameraPosition = .front
                
            } else if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                if captureSession.canAddInput(self.rearCameraInput!) {
                    captureSession.addInput(self.rearCameraInput!)
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
                self.currentCameraPosition = .rear
                
            } else {
                throw CameraControllerError.noCamerasAvailable
            }
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([
                AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                ], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput!) {
                captureSession.addOutput(self.photoOutput!)
            }
        }
        
        func startCaptureSession() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
                try startCaptureSession()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = self.captureSession,
            captureSession.isRunning else {
                completion(nil, CameraControllerError.captureSessionIsMissing)
                return
        }
        
        let settings = AVCapturePhotoSettings()
        
        self.photoCaptureCompletionBlock = completion
        self.photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = .resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition,
            let captureSession = self.captureSession,
            captureSession.isRunning else {
                throw CameraControllerError.captureSessionIsMissing
        }
        
        captureSession.beginConfiguration()
        
        func switchToFrontCamera() throws {
            let inputs = captureSession.inputs as [AVCaptureInput]
            guard let rearCameraInput = self.rearCameraInput,
                inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else {
                    throw CameraControllerError.invalidOperation
            }
            
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.removeInput(rearCameraInput)
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
            }
            self.currentCameraPosition = .front
        }
        
        func switchToRearCamera() throws {
            let inputs = captureSession.inputs as [AVCaptureInput]
            guard let frontCameraInput = self.frontCameraInput,
                inputs.contains(frontCameraInput),
                let rearCamera = self.rearCamera else {
                    throw CameraControllerError.invalidOperation
            }
            
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            captureSession.removeInput(frontCameraInput)
            if captureSession.canAddInput(rearCameraInput!) {
                captureSession.addInput(rearCameraInput!)
            }
            self.currentCameraPosition = .rear
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
        case .rear:
            try switchToFrontCamera()
        }
        
        captureSession.commitConfiguration()
    }
    
}


extension RealCameraController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error{
            self.photoCaptureCompletionBlock?(nil, error)
        } else if let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data) {
            self.photoCaptureCompletionBlock?(image, nil)
        } else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
    
}

enum CameraControllerError: Swift.Error {
    
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
    
}

public enum CameraPosition {
    
    case front
    case rear
    
}

class MockCameraController: NSObject, CameraController {
    
    var frontImage = UIImage(named: "camera_mock")!
    var rearImage = UIImage(named: "camera_mock_back")!
    var cameraPosition = CameraPosition.rear
    var previewLayer = CALayer()
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        setPreviewFrame(image: self.rearImage)
        completionHandler(nil)
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        if self.cameraPosition == CameraPosition.rear {
            completion(self.rearImage, nil)
        } else {
            completion(self.frontImage, nil)
        }
    }
    
    func displayPreview(on view: UIView) throws {
        self.previewLayer.frame = view.bounds
        view.layer.insertSublayer(self.previewLayer, at: 0)
    }
    
    func switchCameras() throws {
        if self.cameraPosition == CameraPosition.rear {
            self.cameraPosition = CameraPosition.front
            setPreviewFrame(image: self.frontImage)
        } else {
            self.cameraPosition = CameraPosition.rear
            setPreviewFrame(image: self.rearImage)
        }
    }
    
    private func setPreviewFrame(image: UIImage) {
        self.previewLayer.contents = image.cgImage!
        self.previewLayer.contentsScale = 2
    }
    
}

struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}

class CameraViewController: UIViewController {
    
    let cameraController: CameraController = Platform.isSimulator ? MockCameraController() : RealCameraController()
    var savedCameraPhotoPath: String? = nil
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewCanvas: UIView!
    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var captureImage: UIImageView!
    
    @IBAction func discardCapture(_ sender: Any) {
        self.captureImage.image = nil
        self.captureView.isHidden = true
        self.previewView.isHidden = false
    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func snapPhoto(_ sender: Any) {
        self.cameraController.captureImage() { image, error in
            guard let image = image else {
                debugPrint("Couldn't capture image: \(error!)")
                return
            }
            self.captureImage.image = image
            self.captureView.isHidden = false
            self.previewView.isHidden = true
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateSpace" {
            
            let vc = segue.destination as! UINavigationController
            let csvc = vc.visibleViewController as! CreateSpaceViewController
            csvc.cameraPhoto = self.captureImage.image
        }
    }
    
    @IBAction func switchCameras(_ sender: Any) {
        do {
            try self.cameraController.switchCameras()
        } catch {
            debugPrint("Failed to switch cameras: \(error)")
        }
    }
    
    @objc func hidePrompt(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.viewWithTag(22)?.alpha = 0
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.viewWithTag(21)?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.hidePrompt(_:))))
        
        self.cameraController.prepare {(error) in
            if let error = error {
                debugPrint("Failed to start CameraController: \(error)")
            }
            
            do {
                try self.cameraController.displayPreview(on: self.previewCanvas)
            } catch {
                debugPrint("Couldn't preview camera: \(error)")
            }
        }
    }
    
}
