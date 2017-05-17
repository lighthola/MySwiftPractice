//
//  ViewController.swift
//  SlotMachine
//
//  Created by Bevis Chen on 2016/11/8.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK:- IBOutlet
    @IBOutlet weak var slotPicker: UIPickerView!
    @IBOutlet weak var slotHandleBaseView: UIView!
    @IBOutlet weak var slotHandleView: UIView!

    
    
    // MARK:- Variable
    var transformLayer = CATransformLayer()
    
    // MARK:- Constant
    let emojis = ["👻","👸","💩","😘","🍔","🤖","🍟","🐼","🚖","🐷"]
    lazy var datas:[[Int]] = {
        
        var data1 = [Int]()
        data1.random100()
        var data2 = [Int]()
        data2.random100()
        var data3 = [Int]()
        data3.random100()
        
        return [data1, data2, data3]
    }()
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slotPicker.selectRow(50, inComponent: 0, animated: false)
        slotPicker.selectRow(50, inComponent: 1, animated: false)
        slotPicker.selectRow(50, inComponent: 2, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        slotPicker.subviews[1].isHidden = true
        slotPicker.subviews[2].isHidden = true
        
        // To get real frame at viewDidAppear
        setSlotHandle()
    }
    
    // Set UI
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    private func setSlotHandle() {
        
        let slotTap = UITapGestureRecognizer(target: self, action: #selector(slotHandlePressed))
        self.slotHandleBaseView.addGestureRecognizer(slotTap)
        
        var newFrame = self.slotHandleView.bounds
        newFrame.size.height /= 2
        newFrame.origin.y = newFrame.size.height / 2
        
        transformLayer.frame = newFrame
        var transform3D = CATransform3DIdentity
        let angle = CGFloat.pi / 9
        transform3D = CATransform3DRotate(transform3D, angle, -1, 1, 0)
        transformLayer.transform = transform3D
        transformLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.slotHandleView.layer.addSublayer(transformLayer)
        
        let layer1 = CALayer()
        layer1.frame = transformLayer.bounds
        layer1.backgroundColor = UIColor.orange.cgColor
        transformLayer.addSublayer(layer1)
        
        let layer2 = CALayer()
        layer2.frame = transformLayer.bounds
        layer2.backgroundColor = UIColor.brown.cgColor
        var transform = CATransform3DMakeTranslation(layer2.bounds.size.width / 2 , 0, layer2.bounds.size.width / 2);
        transform = CATransform3DRotate(transform, CGFloat.pi / 2, 0, 1, 0);
        layer2.transform = transform;
        transformLayer.addSublayer(layer2);
        
        let layer3 = CALayer()
        layer3.frame = transformLayer.bounds
        layer3.backgroundColor = UIColor.purple.cgColor
        transform = CATransform3DMakeTranslation(-layer3.bounds.size.width / 2 , 0, layer3.bounds.size.width / 2);
        transform = CATransform3DRotate(transform, CGFloat.pi / 2, 0, 1, 0);
        layer3.transform = transform;
        transformLayer.addSublayer(layer3);
        
        let layer4 = CALayer()
        layer4.frame = transformLayer.bounds
        layer4.backgroundColor = UIColor.lightGray.cgColor
        transform = CATransform3DMakeTranslation(0 , 0, layer4.bounds.size.width);
        layer4.transform = transform;
        layer4.addSublayer(setTextLayer())
        transformLayer.addSublayer(layer4);
        
        let layer5 = CALayer()
        var layer5Frame = transformLayer.bounds
        layer5Frame.size.height = layer5Frame.size.width
        layer5.frame = layer5Frame
        layer5.backgroundColor = UIColor.black.cgColor
        transform = CATransform3DMakeTranslation(0 , -layer3.bounds.size.width / 2, layer3.bounds.size.width / 2);
        transform = CATransform3DRotate(transform, CGFloat.pi / 2, 1, 0, 0);
        layer5.transform = transform;
        transformLayer.addSublayer(layer5);

    }
    
    private func setTextLayer() -> CATextLayer {
        
        let textLayer = CATextLayer()
        textLayer.frame = transformLayer.bounds
        textLayer.string = "pull\nhandle"
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.fontSize = 16
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.foregroundColor = UIColor.black.cgColor
        return textLayer
    }
    
    // MARK:- IBAction Methods
    func slotHandlePressed() {
        
        var transform3D = self.transformLayer.transform
        transform3D.m34 = -1.0 / 500.0
        var angle = CGFloat.pi * 5/6
        transform3D = CATransform3DRotate(transform3D, angle, -1, 0, 0)
        
        let timeFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        CATransaction.setAnimationTimingFunction(timeFunction)
        CATransaction.setAnimationDuration(0.5)
        
        // completionBlock need to set before transform changed
        CATransaction.setCompletionBlock {
        
            transform3D = CATransform3DIdentity
            transform3D = CATransform3DRotate(transform3D, CGFloat.pi / 9, -1, 1, 0)
            transform3D.m34 = 0.0
            angle = CGFloat(0)
            transform3D = CATransform3DRotate(transform3D, angle, 1, 0, 0)
            
            CATransaction.setAnimationDuration(0.5)
            
            CATransaction.begin()
            self.transformLayer.transform = transform3D
            CATransaction.commit()
        }
        
        CATransaction.begin()
        self.transformLayer.transform = transform3D
        CATransaction.commit()
        
        // Start Slot Machine
        for index in 0 ... 2 {
            slotPicker.selectRow(Int(arc4random_uniform(99)), inComponent: index, animated: true)
        }
    }
    
    // MARK:- UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 100
    }
    
    // MARK:- UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: "Apple Color Emoji", size: 100)
        
        switch component {
        case 0:
            textLabel.text = emojis[datas[0][row]]
        case 1:
            textLabel.text = emojis[datas[1][row]]
        case 2:
            textLabel.text = emojis[datas[2][row]]
        default:
            fatalError("error in")
        }
        
        return textLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.size.width / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.bounds.size.height / 2
    }

    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

// Adding Constraints to Protocol Extensions
extension RangeReplaceableCollection where Iterator.Element == Int {
    mutating func random100() {
        for _ in 1...100 {
            append(Int(arc4random_uniform(10)))
        }
    }
}
