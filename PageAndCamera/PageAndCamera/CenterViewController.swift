//
//  CenterViewController.swift
//  PageAndCamera
//
//  Created by Bevis Chen on 2016/10/18.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import AVFoundation


class CenterViewController: UIViewController {

    // MARK:- IBOutlet
    
    
    // MARK:- Variable
    var imageView: UIImageView?
     
    // MARK:- Constant
    let captureSession = AVCaptureSession()
    let imageOutput = AVCaptureStillImageOutput()
    @available(iOS 10.0, *)
    var photoOutput: AVCapturePhotoOutput? { return AVCapturePhotoOutput() }
    
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCameraView()
    }
    
    // MARK:- Set UI
    private func setCameraView() {
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if let captureDeviceInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) {
            
            captureSession.addInput(captureDeviceInput)
            captureSession.sessionPreset = AVCaptureSessionPreset1920x1080
            captureSession.startRunning()
            
            if #available(iOS 10, *) {
                
            } else {
                
                imageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                if captureSession.canAddOutput(imageOutput) {
                    captureSession.addOutput(imageOutput)
                }
                
                if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                    
                    previewLayer.frame = self.view.bounds
                    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.view.layer.addSublayer(previewLayer)
                    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPhoto)))
                }
            }
        }
    }
    
    // MARK:- Private Methods
    @objc private func showPhoto() {
        
        guard imageView == nil else {
            imageView?.removeFromSuperview()
            imageView = nil
            return
        }
        
        if let videoConnection = imageOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            imageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataBuffer, error) in
                
                let imageDate = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                self.imageView = UIImageView(image: UIImage(data: imageDate!))
                self.imageView?.frame = self.view.bounds
                self.view.addSubview(self.imageView!)
            })
        }
    }

    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
