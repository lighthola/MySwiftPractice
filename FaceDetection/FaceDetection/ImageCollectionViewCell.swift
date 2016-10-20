//
//  ImageCollectionViewCell.swift
//  FaceDetection
//
//  Created by Bevis Chen on 2016/10/20.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK:- IBOutlet
    @IBOutlet weak var imageView: FaceDetectionImageView! {
        didSet {
            print("Cell Did Set.")
        }
    }
    
    // MARK:- Variable
    
    // MARK:- Constant

    // MARK:-
}

class FaceDetectionImageView: UIImageView {
    
    // MARK:- Variable
    override var image: UIImage? {
        didSet {
            print("Image Did Set.")
        }
    }
    
    var tmpImage: UIImage?
    // MARK:- Constant
    
    // MARK:-
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // need to enable userInteractionEnabled on storyboard
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FindFace)))
    }
    
    // MARK:- private Methods
    @objc fileprivate func FindFace() {
        
        guard let image = CIImage(image: self.image!) else {
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
        
        tmpImage = self.image
        
        for (index, item) in faces!.enumerated() {
            
            let face = item as! CIFaceFeature
            
            print("--")
            
            if face.hasSmile {
                print(" Face \(index) has Smile, at \(face.mouthPosition)")
                tmpImage = drawAt(face.mouthPosition)
            }
            
            if face.hasLeftEyePosition {
                print(" Face \(index) has Left Eye, at \(face.leftEyePosition)")
                tmpImage = drawAt(face.leftEyePosition)
            }
            
            if face.hasRightEyePosition {
                print(" Face \(index) has Right Eye, at \(face.rightEyePosition)")
                tmpImage = drawAt(face.rightEyePosition)
            }
            
            print("--")
        }
        
        self.image = tmpImage
    }
    
    fileprivate func drawAt(_ point: CGPoint) -> UIImage {
        
        var image: UIImage = tmpImage!
        
        // canvas size
        UIGraphicsBeginImageContext(image.size)
        
        // Start draw at context (0, 0)
        image.draw(at: CGPoint(x: 0, y: 0))
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(CGLineCap.round)
        context?.setLineJoin(CGLineJoin.round)
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(20.0)
        context?.move(to: point)
        context?.addLine(to: point)
        context?.strokePath()
        
        // get new image frome context
        image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
