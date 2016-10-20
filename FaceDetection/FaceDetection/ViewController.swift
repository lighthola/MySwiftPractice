//
//  ViewController.swift
//  FaceDetection
//
//  Created by Bevis Chen on 2016/10/19.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK:- Variable
    
    
    // MARK:- Constant
    let images = ["1", "2"]
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: images[0])
        FindFace()
    }

    // MARK:- Private Methods
    fileprivate func FindFace() {
        
        guard let image = CIImage(image: imageView.image!) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorTypeFace]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = detector?.features(in: image, options: [CIDetectorSmile: true, CIDetectorEyeBlink: true])
        
        guard faces?.count != 0 else {
            print("-- \n No Face!! \n--")
            return
        }
        
        print("-- \n \(faces!.count) Face!! \n--")
        
        for (index, item) in faces!.enumerated() {
            
            let face = item as! CIFaceFeature
            
            print("--")
            
            if face.hasSmile {
                print(" Face \(index) has Smile, at \(face.mouthPosition)")
                drawAt(face.mouthPosition)
            }
            
            if face.hasLeftEyePosition {
                print(" Face \(index) has Left Eye, at \(face.leftEyePosition)")
                drawAt(face.leftEyePosition)
            }
            
            if face.hasRightEyePosition {
                print(" Face \(index) has Right Eye, at \(face.rightEyePosition)")
                drawAt(face.rightEyePosition)
            }
            
            print("--")
        }
        
    }
    
    fileprivate func drawAt(_ point: CGPoint) {
        
        let image = imageView.image!
        
        // canvas size
        UIGraphicsBeginImageContext(image.size)
        
        // Start draw at context (0, 0)
        image.draw(at: CGPoint(x: 0, y: 0))
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(CGLineCap.round)
        context?.setLineJoin(CGLineJoin.round)
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(5.0)
        context?.move(to: point)
        context?.addLine(to: point)
        context?.strokePath()
        
        // get new image frome context
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

