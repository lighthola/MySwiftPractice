//
//  MyLabel.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Bevis Chen on 2017/4/20.
//  Copyright © 2017年 Arthur Knopper. All rights reserved.
//

import UIKit

@IBDesignable
class MyLabel: UIView {

    @IBInspectable
    var text: NSString = "text" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var fontSize: CGFloat = 17 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var maskBGColor: UIColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        /*
        //UIGraphicsBeginImageContext(rect.size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attrs: [String: Any] = [
            NSFontAttributeName           : UIFont.systemFont(ofSize: fontSize),
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName : paragraph]
        let drawContext = NSStringDrawingContext()
        drawContext.minimumScaleFactor = 0.1
        
        //text.size(attributes: attrs);
        //text.draw(at: rect.origin, withAttributes: attrs)
        text.draw(with: rect, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attrs, context: drawContext)
        //text.draw(in: rect, withAttributes: attrs)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return
        }
        UIGraphicsEndImageContext()
        
        guard let c = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // upside-down the context,
        c.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: rect.height))
        guard let mask = CGImage(maskWidth: image.width, height: image.height, bitsPerComponent: image.bitsPerComponent, bitsPerPixel: image.bitsPerPixel, bytesPerRow: image.bytesPerRow, provider: image.dataProvider!, decode: image.decode, shouldInterpolate: image.shouldInterpolate) else {
            return
        }
        
        c.clear(rect)
        // save Current Context State
        c.saveGState()
        
        c.clip(to: rect, mask: mask)
        
        maskBGColor.set()
        c.fill(rect)
        
        // restore Current Context State to the most recently saved
        c.restoreGState()
        // */
 
        //testSaveAndRestore(rect)
        
        embossedArc(rect)
    }
    
    fileprivate func testSaveAndRestore(_ rect: CGRect) {
        
        guard let c = UIGraphicsGetCurrentContext() else {
            return;
        }
        
        c.saveGState()
        
        //c.setFillColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1).cgColor)
        c.setStrokeColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        c.setLineWidth(5)
        
        c.saveGState()
        
        c.setStrokeColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor)
        // 1 and 5 are dash width, 3 and 4 are white space width.
        c.setLineDash(phase: 0, lengths: [1, 3, 5 , 4])
        c.move(to: CGPoint(x: 10, y: 10))
        c.addLine(to: CGPoint(x: 10, y: 100))
        c.strokePath()
        
        c.restoreGState()
        
        c.move(to: CGPoint(x: 20, y: 10))
        c.addLine(to: CGPoint(x: 20, y: 100))
        c.strokePath()
        
        c.restoreGState()
    }
    
    fileprivate func embossedArc(_ rect:CGRect) {
        
        guard let c = UIGraphicsGetCurrentContext() else {
            return;
        }
        
        // 1. create an arc path
        let arcThickness: CGFloat = 20
        let arcBounds = rect.insetBy(dx: 10, dy: 10) // rect with padding
        let center = CGPoint(x: arcBounds.midX, y: arcBounds.midY)
        let radius: CGFloat = 0.5 * (min(arcBounds.width, arcBounds.height) -  arcThickness)
        let arc = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi/3, endAngle: -2 * CGFloat.pi/3, clockwise: true)
        /*
        // Style of start and end points
        arc.lineCapStyle = .square
        // Style of junctions between connected line segments.
        arc.lineJoinStyle = .round
        // To avoid spikes(尖銳化) when miter join style.
        arc.miterLimit = 100
        arc.lineWidth = 30
        #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).setStroke()
        arc.stroke()
        // */
        
        // 2. copy path form arc with some settings.
        let shape = CGPath(__byStroking: arc.cgPath, transform: nil, lineWidth: arcThickness, lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 10)
        
        // 3. inverse arc
        let shapeInverse = shape?.mutableCopy()
        shapeInverse?.addRect(.infinite)
        
        // 4. draw an arc
        c.beginPath()
        c.addPath(shape!)
        c.setFillColor(UIColor(white: 0.9, alpha: 1).cgColor)
        c.fillPath()
        
        // 5. saving graphics state and clipping a mask from arc.
        c.saveGState()
        
        c.beginPath()
        c.addPath(shape!)

//        var transform = CGAffineTransform(scaleX: 1, y: 0.25).translatedBy(x: 0, y: rect.height)
//        let rectangle = CGPath(rect: rect, transform: &transform)
//        c.addPath(rectangle)
        
        c.clip()
        
        
        // 6. setting shadow to next path
        c.setShadow(offset: .zero, blur: 7, color: UIColor(white: 0, alpha:0.5).cgColor)

        // 7. Drawing inverse arc with shadow in mask(arc's area).
        //    because inverse arc can't draw anything on arc's area, 
        //    so only draw shadow.
        //    Inverse arc's shadow is equal arc's to inner shadow.
        c.beginPath()
        c.addPath(shapeInverse!)
        c.fillPath()
        
        // 8. restoring graphics state
        c.restoreGState()
        
        // 9. To increase inner shadow of arc by using stroke path.
        c.setStrokeColor(UIColor(white: 0.75, alpha: 1).cgColor)
        c.setLineWidth(1)
        c.setLineJoin(.round)
        c.beginPath()
        c.addPath(shape!)
        c.strokePath()

    }
}
