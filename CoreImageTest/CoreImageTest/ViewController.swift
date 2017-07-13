//
//  ViewController.swift
//  CoreImageTest
//
//  Created by Bevis Chen on 2017/6/27.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let context = CIContext(options: nil)
    var originalImage = UIImage(named: "image")!
    var vecter = CIVector()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let filterNames = CIFilter.filterNames(inCategory: kCICategoryBuiltIn)
        
        for filterName in filterNames {
            let filter = CIFilter(name: filterName)
            print("\rfilter:\(filterName)\rattributes:\(filter!.attributes)")
        }
    }

    @IBAction func inputCenterChanged(_ sender: UISlider) {
        vecter = CIVector(x: CGFloat(sender.value), y: CGFloat(sender.value))
        print(vecter)
        pixelFullBtnPressed(vecter)
    }
    
    @IBAction func pixelFullBtnPressed(_ sender: Any) {
        
        if let filter = CIFilter(name: "CIPixellate") {
            let inputImage = CIImage(image: originalImage)
            
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            
            // the effect fo pixelate
            //filter.setValue(25, forKey: kCIInputScaleKey)
            filter.setValue(vecter, forKey: kCIInputCenterKey)
            if let fullPixellateImage = filter.outputImage {
                // Don't use below method to create UIImage
                // imageView.image = UIImage(ciImage:fullPixellateImage)
                // Renders the image to specific region
                if let cgImage = context.createCGImage(fullPixellateImage, from: fullPixellateImage.extent) {
                    imageView.image = UIImage(cgImage: cgImage)
                }
            }
        }
    }

    @IBAction func pixelPartBtnPressed(_ sender: Any) {
        if let filter = CIFilter(name: "CIPixellate") {
            if let inputImage = CIImage(image: originalImage) {
                filter.setValue(inputImage, forKey: kCIInputImageKey)
                filter.setValue(25, forKey: kCIInputScaleKey)
                if let fullPixellateImage = filter.outputImage {
                    // Create mask
                    var maskImage: CIImage
                    
                    // the first pixelate region (the Big one)
                    var centerX = inputImage.extent.size.width / 2
                    let centerY = inputImage.extent.size.height / 2
                    var radius = min(inputImage.extent.size.width/3, inputImage.extent.size.height/3)
                    var temp = createMaskImage(rect: inputImage.extent, centerX: centerX, centerY: centerY,
                                               radius: radius)
                    maskImage = temp
                    
                    // the second pixelate region (the small one)
                    centerX = inputImage.extent.size.width / 6
                    radius = min(inputImage.extent.size.width/4, inputImage.extent.size.height/5)
                    temp = createMaskImage(rect: inputImage.extent, centerX: centerX, centerY: centerY,
                                           radius: radius)
                    //maskImage = CIFilter(name: "CISourceOverCompositing", withInputParameters: [kCIInputImageKey : temp, kCIInputBackgroundImageKey : maskImage ])!.outputImage!
                    
                    // Blend image with mask
                    let blendFilter = CIFilter(name: "CIBlendWithMask")!
                    blendFilter.setValue(fullPixellateImage, forKey: kCIInputImageKey)
                    blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
                    blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
                    
                    let blendOutputImage = blendFilter.outputImage
                    if let blendCGImage = context.createCGImage(blendOutputImage!, from: blendOutputImage!.extent) {
                        imageView.image = UIImage(cgImage: blendCGImage)
                    }
                    
                }
            }
        }
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        imageView.image = originalImage
    }
    
    func createMaskImage(rect: CGRect ,centerX: CGFloat, centerY: CGFloat, radius:CGFloat) -> CIImage {
        
        // more detail: http://blog.csdn.net/qqyinzhe/article/details/51523494
        //
        // the color 0 has to be green for pixelate.
        // alpha: (clear image) 0 ~ 1 (show image)
        let radialGradient = CIFilter(name: "CIRadialGradient",
                                      withInputParameters: [
                                            "inputRadius0" : radius,
                                            "inputRadius1" : radius + 10,
                                            "inputColor0" : CIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                            "inputColor1" : CIColor(red: 0, green: 0, blue: 0, alpha: 0),
                                            kCIInputCenterKey : CIVector(x: centerX, y: centerY)
            ]
        )
        let radialGradientOutputImage = radialGradient!.outputImage!.cropping(to: rect)
        return radialGradientOutputImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

