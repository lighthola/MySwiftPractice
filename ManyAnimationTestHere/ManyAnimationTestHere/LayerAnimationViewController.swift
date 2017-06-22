//
//  LayerAnimationViewController.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Bevis Chen on 2017/4/21.
//  Copyright © 2017年 Arthur Knopper. All rights reserved.
//

import UIKit

class LayerAnimationViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var view1: UIView! {
        didSet {
            
        }
    }
    @IBOutlet weak var view2: UIView! {
        didSet {
            
        }
    }
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var heartView: HeartView!
    
    let aCALayer = CALayer()
    let aCAShapelayer = CAShapeLayer()
    let mask = CAShapeLayer()
    
    lazy var ball: CAShapeLayer = {
        
        /*
         Set the position property instead of the arc center of path for correctly animate the position property of layer.
         */
        
        let ball = CAShapeLayer()
        ball.path = UIBezierPath(arcCenter: CGPoint.zero, radius: 30, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
        ball.fillColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 0.75).cgColor
        
        ball.position = self.view.center
        
        return ball
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sol = Solution()
        //print(sol.twoSum([3, 3], 6))
        //print(sol.twoSum([3, 2, 4], 6))
        
        let list1 = ListNode(1)
        let list2 = ListNode(2)
        let list3 = ListNode(3)
        list1.next = list2
        list2.next = list3
        
        let list4 = ListNode(7)
        let list5 = ListNode(8)
        let list6 = ListNode(9)
        list4.next = list5
        list5.next = list6
        
        sol.addTwoNumbers(list1, list4)
        
        sol.lengthOfLongestSubstring("11233")
        
        sol.findMedianSortedArrays([1], [2, 3])
        
        //-------
        
//        let caLayer = CALayer()
//        caLayer.frame = view1.bounds
//        caLayer.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1).cgColor
//        view1.layer.addSublayer(caLayer)

        // Do any additional setup after loading the view.
        
        view.layer.addSublayer(ball)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        print(view1.frame)
//        print(view1.layer.position)
//        print(view1.center)
        
        let oldFrame = view1.frame
        view1.layer.anchorPoint = CGPoint(x: 0, y: 0)
        view1.frame = oldFrame
        
//        print(view1.frame)
//        print(view1.layer.position)
//        print(view1.center)
        
        aCAShapelayer.frame = view2.bounds
        aCAShapelayer.backgroundColor = UIColor.clear.cgColor
        //view2.layer.addSublayer(aCAShapelayer)
    
        
        //let path = UIBezierPath(roundedRect: view3.bounds, cornerRadius: 0.0001)
        
        /*
         Creating a rectangle path with 30 padding to all direction and 20  corner radius, then append a fully rectangle path.
         
         The intersecting/non-intersecting area between two paths can be fill  according to fillRule of CAShapeLayer. If fill rule is kCAFillRuleEvenOdd, the shape layer is going to draw on the non-intersecting area.
         
         If you let the layer as mask, the alpha of fill color must greater than 0.
        */
        let path = UIBezierPath(roundedRect: view3.bounds.insetBy(dx: 30, dy: 30), cornerRadius: 20)
        path.append(UIBezierPath(rect: view3.bounds))
        
        /*
        let mPath = CGMutablePath()
        mPath.addPath(path.cgPath)
        mPath.addRect(view3.bounds)
        // */
        
        mask.path = path.cgPath
        mask.fillColor = UIColor(white: 1, alpha: 0.25).cgColor
        mask.fillRule = kCAFillRuleEvenOdd // default is kCAFillRuleNonZero
        
        view3.layer.addSublayer(mask)
        //view3.layer.mask = mask
        
        heartAnim()
        
        drawPathAnimation()
        
        drawStrokeText()
        
    }
    
    func drawStrokeText() {
        
        /*
         A CTFrame contains many CTLine, A CTLine Contains many CTRun, ACTRun Contains many Glyphs. Glyph is the image of character. 
         If a text as below:
         
        CTRun 1                   CTRun2
        V                         V
        Hellow(1. style: Italics) World!(2. sytle:Bold)<-- CTLine 1 \
                                                       <-- CTLine 3 - CTFrame
        I am Happy.                                    <-- CTLine 2 /
         
         reference: https://read01.com/Pzn3Ka.html
        */
        
        let font = CTFontCreateWithName("PingFangSC-Bold" as CFString?, 60, nil)
        let attrStr = NSAttributedString(string: "Hello Swift!", attributes: [NSFontAttributeName: font])
        let line = CTLineCreateWithAttributedString(attrStr)
        let runArray = CTLineGetGlyphRuns(line)
        
        // Get offset for center-align
        let attrRect = attrStr.boundingRect(with: self.view.bounds.size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let offset =  (self.view.layer.bounds.width - CGFloat(attrRect.width)) / 2 - 10
        
        let letters = CGMutablePath()
        
        for runIndex in 0..<CFArrayGetCount(runArray)
        {
            let runUnsafe: UnsafeRawPointer = CFArrayGetValueAtIndex(runArray, runIndex)
            // To cast forcedly a point to a specific type, in this case, that is Class CTRun.
            let run = unsafeBitCast(runUnsafe, to: CTRun.self)
            
            // To get every glyph at index for creating a path on the specific position.
            for runGlyphIndex in 0..<CTRunGetGlyphCount(run)
            {
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph: CGGlyph = CGGlyph()
                var position: CGPoint = CGPoint()
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                CTRunGetPositions(run, thisGlyphRange, &position)
                
                // To get path of glyph
                let letter = CTFontCreatePathForGlyph(font, glyph, nil)
                let t = CGAffineTransform(translationX: position.x + offset, y: position.y);
                
                if letter == nil {
                    continue
                }
                
                letters.addPath(letter!, transform:t)
            }
        }
        
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 10, y: 440, width: self.view.layer.bounds.width - 20, height: 100)
        layer.isGeometryFlipped = true // Flipping layer for proper text.
        layer.path = letters
        layer.strokeColor = UIColor(white: 0, alpha: 0.25).cgColor
        layer.fillColor = UIColor(white: 0, alpha: 0.1).cgColor
        layer.lineWidth = 3.0
        layer.lineJoin = kCALineJoinBevel
        
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = 5
        anim.fromValue = 0
        anim.toValue = 1
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { 
            layer.add(anim, forKey: "stroke text")
            self.view.layer.addSublayer(layer)
        }
        
    }
    
    @IBAction func slierController(_ sender: UISlider) {
        
        shape.strokeEnd = CGFloat(sender.value)
        
        if shape.strokeEnd >= 1.0 {
            let anim = CABasicAnimation(keyPath: "transform.rotation.z")
            anim.duration = 4
            anim.fromValue = 0
            anim.toValue = CGFloat.pi * 2
            
            anim.repeatCount = .greatestFiniteMagnitude
            
            shape.add(anim, forKey: "rotate circle")
            
            sender.isEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
            self.shape.removeAnimation(forKey: "rotate circle")
            sender.isEnabled = true
        }
    }
    
    var shape = CAShapeLayer()
    
    func drawPathAnimation() {
        
        let rightX = view.bounds.width - 10
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 550))
        path.addLine(to: CGPoint(x: 10, y: 490))
        path.addLine(to: CGPoint(x: view.center.x, y: 440))
        path.addLine(to: CGPoint(x: rightX, y: 490))
        path.addLine(to: CGPoint(x: 10, y: 490))
        path.addLine(to: CGPoint(x: rightX, y: 550))
        path.addLine(to: CGPoint(x: rightX, y: 490))
        path.addLine(to: CGPoint(x: 10, y: 550))
        path.addLine(to: CGPoint(x: rightX, y: 550))
        
        let circlePath = UIBezierPath(arcCenter: CGPoint.zero, radius: 30, startAngle: CGFloat.pi * -0.5, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        shape = CAShapeLayer()
        shape.position        = CGPoint(x: self.view.center.x, y: 495)
        shape.strokeColor     = UIColor.blue.cgColor
        shape.lineWidth       = 15
        shape.lineCap         = kCALineJoinBevel
        shape.lineJoin        = kCALineJoinBevel
        shape.fillColor       = nil
        shape.miterLimit      = 5
        shape.path            = circlePath.cgPath
        
        // drawing dash line
        shape.lineDashPattern = [1, 3]
        
        // set stroke end to 0 for controlling animation by slider.
        shape.strokeStart = 0.0
        shape.strokeEnd   = 0.0
        
        self.view.layer.addSublayer(shape)
        
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration  = 5
        anim.fromValue = 0
        anim.toValue   = 1
        
        //self.shape.add(anim, forKey: "drawing house")
        
    }
    
    
    // Add a Tap gesture to a view on storyboard and connected an IBAction method.
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        
        let additiveAnimationsAreEnabled = true
        
        let touchPoint   = sender.location(in: view)
        
        // for non additive animation
        let presentation = ball.presentation()!
        let currentPoint = presentation.position
        
        let animation            = CABasicAnimation(keyPath: "position")
        animation.duration       = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        
        // use nil when the animation is additive but a key when it's not
        var animationKey: String? = nil
        
        if additiveAnimationsAreEnabled
        {
            animation.isAdditive = true
            
            /*
             The circle's original location is (0, 0) and tapping two times in the view that the locations are (100, 100) and (20, 20).
             If the circle is going to move from (0, 0) to (100, 100) by first tap, but the moving was interrupted by second tap that the circle's presentation position is (50, 50) then move to second tap's position (20, 20). The toValue minus fromValue of additive animaiton is goes by (100, 100), caculate by toValue(0, 0) - fromValue(original(0, 0) - first tap(100, 100)), then be interrupted by second tap and remaining (50, 50)'s moving and add (-80, -80) to current fromValue, caculate by toValue(0, 0) - fromValue(original(100, 100) - first tap(20, 20)), thus the final moving value is (-30, -30), caculate by (50, 50) - (-80, -80), on position (50, 50) and final positon is second tap's position (20, 20).
             */
            
            let difference = CGPoint(
                x: ball.position.x - touchPoint.x,
                y: ball.position.y - touchPoint.y
            )
            
            // from -(new-old) to zero (additive)
            animation.fromValue = NSValue(cgPoint: difference)
            animation.toValue   = NSValue(cgPoint: CGPoint.zero)
            
            print(ball.position)
        }
        else {
            // from old to new
            animation.fromValue = NSValue(cgPoint: currentPoint)
            animation.toValue   = NSValue(cgPoint: touchPoint)
            
            animationKey = "move the layer"
        }
        
        
        // disable the implicit animat ion
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        ball.position = touchPoint
        CATransaction.commit()
        
        // add the explicit animtion
        ball.add(animation, forKey:animationKey)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        /*
        
        if let location = touches.first?.location(in: view) {
            
            let oldLocation = CGPoint(x: ball.position.x - location.x, y: ball.position.y - location.y)
            
            let anim = CABasicAnimation(keyPath: "position")
            anim.isAdditive = true
            anim.duration = 1.5
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            anim.fromValue = NSValue(cgPoint: oldLocation)
            anim.toValue = NSValue(cgPoint: CGPoint.zero)
            
            // disable the implicit animation
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            ball.position = location
            CATransaction.commit()
            
            ball.add(anim, forKey: nil)
        }
         // */
    }
    
    
    // MARK: - action methods
    func heartAnim() {
        
        let line = UIBezierPath()
        line.move(to: heartView.ball.position)
        line.addLine(to: CGPoint(x: heartView.ball.position.x + 100, y: heartView.ball.position.y))
        
        /*
         You may need to set an offset to adjust the position by referring the position relative to the path and the attached layer.
         */
        let heartPath             = heartView.heartPath.copy() as! UIBezierPath
        let offset                = CGAffineTransform(translationX: -heartView.heartPath.currentPoint.x, y: -heartView.heartPath.currentPoint.y)
        heartPath.apply(offset)
        
        /*
         If to set "isAdditive" to ture for CAAnimation that would combine all animation on the same key path, as below, the ball will move along the heart path and round a circle path at same time by a new animation as a result of concatenating two animations at the position property.
         */
        
        let animHeart             = CAKeyframeAnimation(keyPath: "position")
        animHeart.path            = heartPath.cgPath
        animHeart.isAdditive      = true
        animHeart.repeatCount     = .greatestFiniteMagnitude
        animHeart.duration        = 5
        animHeart.calculationMode = kCAAnimationPaced // An even pace(均速) throughout the animation
        
        let roundPath             = UIBezierPath(arcCenter: CGPoint.zero, radius: 5, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let animRound             = CAKeyframeAnimation(keyPath: "position")
        animRound.path            = roundPath.cgPath
        animRound.isAdditive      = true
        animRound.repeatCount     = .greatestFiniteMagnitude
        animRound.duration        = 0.275
        animRound.calculationMode = kCAAnimationPaced
        
        heartView.ball.add(animHeart, forKey: "circle along heart")
        heartView.ball.add(animRound, forKey: "round")
    }
    
    @IBAction func go3(_ sender: Any) {
        
        let v4PositionX = view4.layer.position.x
        let v5PositionX = view5.layer.position.x
        
        let anim1 = CABasicAnimation(keyPath: "position.x")
        anim1.duration = 3
        anim1.fromValue = v4PositionX
        //anim1.toValue = v4PositionX + 100
        anim1.isAdditive = true
        
        let anim2 = CABasicAnimation(keyPath: "position.x")
        anim2.duration = 1
        anim2.fromValue = v5PositionX
        //anim2.toValue = v5PositionX + 100
        anim2.isAdditive = true
        
        view4.layer.position.x = v4PositionX + 100
        
        view4.layer.add(anim1, forKey: nil)
        view4.layer.add(anim2, forKey: nil)
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            self.view5.layer.position.x = v5PositionX + 100
//        }
        view5.layer.position.x = v5PositionX + 100
        
        
        
    }

    @IBAction func goBtnPressed(_ sender: Any) {
        
        
        ///*
        goBtnAction2()
        return
        // */
        
    //* ------------------------------------------ *//
        
        /* or
         if view2.layer.sublayers == nil {
            view2.layer.addSublayer(aCAShapelayer)
         }
         // */
        if let layers = view2.layer.sublayers {
            if !layers.contains(aCAShapelayer) {
                view2.layer.addSublayer(aCAShapelayer)
            }
        }
        else {
            view2.layer.addSublayer(aCAShapelayer)
        }
        
        let animate:()->Void = {
            
            /*
             All animatable properties of CALayer have 0.25 seconds animation
             by default, or can be called "Implicit Animations". CATransaction
             is used to control the animation of these properties.
             
             If you want to disable animation, call
             - CATransaction.setDisableActions(true).
             */
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(2)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
            
            CATransaction.setCompletionBlock {
                
                /*
                 If you want to modify layer transform and background color at same time, maybe to do like below:
                 */
                UIView.animate(withDuration: 2, animations: {
                    
                    // transform can't draw animation by CATransaction.
                    self.view1.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi * -3), 0, 0, 1)
                    self.view1.transform = CGAffineTransform(translationX: 0, y: -50)
                    self.view2.transform = CGAffineTransform(translationX: 0, y: 20)
                    
                    // To change bg color by CATransaction
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(2)
                    self.aCAShapelayer.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1).cgColor
                    CATransaction.commit()
                })
            }
            
            // draw animation here.
            self.aCAShapelayer.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor
            
            CATransaction.commit()
        }
        
        //
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.0001) {
            
            animate()
        }
    }
    
    
    func goBtnAction2() {
    
//        if view2.layer.sublayers == nil {
//            view2.layer.addSublayer(aCAShapelayer)
//        }
        
        let keyAnim1 = CAKeyframeAnimation(keyPath: "backgroundColor")
        keyAnim1.beginTime             = CACurrentMediaTime()
        keyAnim1.duration              = 4
        keyAnim1.keyTimes              = [0.0, 0.5, 1.0] // must be 0.0 to 1.0
        keyAnim1.calculationMode       = kCAAnimationLinear
        keyAnim1.timingFunctions       = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        ]
        keyAnim1.values                = [
            view2.backgroundColor?.cgColor ?? UIColor.clear.cgColor,
            #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor,
            #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor
        ]
        
        /*
         If you duplicate set same property on sub-animations and group-animation, such as duration, animation may failed.
         */
        let keyAnim2 = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        keyAnim2.keyTimes              = [0.0, 1.0]
        keyAnim2.values                = [0, CGFloat.pi * 2]
        
        let keyAnim3 = CABasicAnimation(keyPath: "transform.translation.y")
        keyAnim3.fromValue             = 0.0
        keyAnim3.toValue               = -50
        
        let keyAnim4 = CAKeyframeAnimation(keyPath: "transform.translation.y")
        keyAnim4.duration              = 2
        keyAnim4.beginTime             = CACurrentMediaTime() + 2.0
        keyAnim4.keyTimes              = [0.0, 1.0]
        keyAnim4.values                = [0, 20]
        

        let animGroup1 = CAAnimationGroup()
        animGroup1.duration   = 2
        animGroup1.beginTime  = CACurrentMediaTime() + 2
        animGroup1.animations = [keyAnim2, keyAnim3]
        
        /*
         If you want to actually change the properties after animation, may call CATransaction as below:
         */
        
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock {
            self.view2.layer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor
            self.view2.layer.transform = CATransform3DMakeTranslation(0, 20, 0)
            
            self.view1.layer.transform = CATransform3DTranslate(CATransform3DMakeRotation(CGFloat.pi * -2, 0, 0, 1), 0, -50, 0)
        }
        
            // You can add multiple animation at one layer.
            view1.layer.add(animGroup1, forKey: nil)
            view2.layer.add(keyAnim4, forKey: nil)
            view2.layer.add(keyAnim1, forKey: nil)
        
        CATransaction.commit()
        
        
    }
    
    
    @IBAction func go2(_ sender: Any) {
        
//        let mask = CAShapeLayer()
//        mask.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
//        mask.path = UIBezierPath(roundedRect: view3.bounds, cornerRadius: 0.0001).cgPath
//        view3.layer.addSublayer(mask)
        
        
        
        //let path = UIBezierPath(roundedRect:view3.bounds.insetBy(dx: 30, dy: 0), cornerRadius: 0.0001)

//        let path = UIBezierPath(roundedRect: view3.bounds.insetBy(dx: 10, dy: 10), cornerRadius: 20)
//        path.append(UIBezierPath(rect: rect))
        //mask.fillRule = kCAFillRuleEvenOdd
        ///*
        
        
        
        /*
         CABasicAnimaiton can draw animation for animiatable properties of Layer.
         
         The path should have to set same number of elements for correctly animate. For instance, first path has 3 elements, like rect, corner radius, additional path, then second path is the same.
         */
        let path = UIBezierPath(roundedRect: view3.bounds, cornerRadius: 0.0001)
        path.append(UIBezierPath(rect: view3.bounds))
        
        let anim = CABasicAnimation(keyPath: "path")
        anim.delegate              = self
        
        /* 
         http://www.jianshu.com/p/91fccd32f6fb
         
         You can set fillMode to kCAFillModeForwards and isRemovedOnCompletion to false for keep animation completion state when animation is stopped.
        */
//        anim.fillMode              = kCAFillModeForwards
//        anim.isRemovedOnCompletion = false
        
        /*
         http://stackoverflow.com/questions/9629346/difference-between-css3-transitions-ease-in-and-ease-out#9636239
         EaseIn   : start slowly
         EaseOut  : finish slowly
         EaseInOut: start and finish slowly
         */
        anim.timingFunction        = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.autoreverses          = false
        anim.repeatCount           = 2 // if .greatestFiniteMagnitude(最大有限幅度) for infinite repeat
        
        anim.duration              = 1
        anim.fromValue             = mask.path
        anim.toValue               = path.cgPath

        /*
         If you want to explicit animation who have to set the property with a
         call like:
         
         mask.path = path.cgPath
        */

        mask.path = path.cgPath
        mask.add(anim, forKey: nil)
    }
    
    // MARK: - CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let basicAnim = anim as? CABasicAnimation else {
            return;
        }
        
        guard basicAnim.keyPath == "path" else {
            return
        }
        
        if !flag
        {
            let rect = view3.bounds
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 0.0001)
            
            let anim = CABasicAnimation(keyPath: "path")
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            anim.delegate = self
            anim.isRemovedOnCompletion = true
            anim.fillMode = kCAFillModeForwards
            
            anim.duration       = 1
            anim.fromValue      = mask.presentation()?.path
            anim.toValue        = path.cgPath
            
            mask.removeAnimation(forKey: "path")
            
            mask.add(anim, forKey: nil)
        }
    }
    
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
