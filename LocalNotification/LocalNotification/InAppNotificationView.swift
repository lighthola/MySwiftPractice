//
//  IndicatorBlurView.swift
//  IndicatorBlurView
//
//  Created by Bevis Chen on 2017/8/30.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit


class InAppNotificationView: UIView {
    var removeAction: DispatchWorkItem!
    var tapAction: (()->())?
    
    @discardableResult
    @objc
    class func show(icon: UIImage? = UIApplication.shared.icon,
                    title: String = "本地通知",
                    message: String,
                    after delay: TimeInterval = 0.25,
                    tapAction: (()->())? = nil) -> InAppNotificationView? {

        //Why is main window of type double optional?
        //https://stackoverflow.com/questions/28901893/why-is-main-window-of-type-double-optional/28902549#28902549
        guard let window = UIApplication.shared.delegate?.window??.`self`(), let contentView = window.subviews.first else {
            return nil
        }
        
        // to show
        let ianv = InAppNotificationView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: 70))
        ianv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(ianv)
        
        ianv.appiconImageView.image = icon
        ianv.localNotificationLabel.text = title
        ianv.timeLabel.text = "現在"
        ianv.messageLabel.text = message
        
        
        ianv.transform = CGAffineTransform(translationX: 0, y: -70)
        UIView.animate(withDuration: 0.25, delay: delay, options: .curveEaseIn, animations: {
            ianv.transform = CGAffineTransform.identity
            window.windowLevel = UIWindowLevelStatusBar + 1
        }) { (_) in
//            ianv.removeFromSuperview()
        }
        
        // to remove
        let removeAction = DispatchWorkItem { [unowned ianv] in
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                ianv.transform = CGAffineTransform(translationX: 0, y: -70)
            }) { (_) in
                ianv.removeFromSuperview()
                window.windowLevel = UIWindowLevelNormal
            }
        }
        ianv.removeAction = removeAction
        let delay: DispatchTime = DispatchTime.now() + delay + 10
        DispatchQueue.main.asyncAfter(deadline: delay, execute: removeAction)

        ianv.tapAction = tapAction
        
        return ianv
    }
    
    func cancelShow() {
        layer.removeAllAnimations()
        remove()
    }
    
    private func remove() {
        objc_sync_enter(self)
        if !removeAction.isCancelled {
            removeAction.perform()
            removeAction.cancel()
        }
        objc_sync_exit(self)
    }
    
    @IBAction func swipeUpActon(_ sender: Any) {
        remove()
    }
    
    @IBAction func tapAction(_ sender: Any) {
        if tapAction != nil {
            tapAction!()
            remove()
        }
    }
    
    // MARK:- View
    @IBOutlet private var containerView: UIView!
    @IBOutlet weak var appiconImageView: UIImageView! {
        didSet {
            appiconImageView.layer.masksToBounds = true
            appiconImageView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var localNotificationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet private var tapGesture: UITapGestureRecognizer!
    @IBOutlet private var swipeUpGesture: UISwipeGestureRecognizer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    deinit {
        printD("")
    }
    
    private func layoutView() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        // Base
        let baseView = UIView()
        baseView.frame = bounds
        baseView.autoresizingMask = [.flexibleWidth]
        baseView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        addSubview(baseView)

        // Pole
        let rect = CGRect(x: bounds.width / 2 - 25, y: bounds.height - 5 - 4, width: 50, height: 5)
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect = UIBlurEffect(style: .light)
            let poleView = UIVisualEffectView(effect: blurEffect)
            poleView.frame = rect
            poleView.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
            poleView.layer.cornerRadius = rect.height / 2
            poleView.clipsToBounds = true
            addSubview(poleView)
        } else {
            let poleView = UIView()
            poleView.frame = rect
            poleView.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
            poleView.layer.cornerRadius = rect.height / 2
            poleView.clipsToBounds = true
            poleView.backgroundColor = UIColor(white: 1, alpha: 0.7)
            addSubview(poleView)
        }
        
        // Xib
        if let view = Bundle.main.loadNibNamed(String(describing: InAppNotificationView.self), owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth]
            addSubview(view)
        }
    }
}

@objc
extension UIApplication {
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
            // First will be smallest for the device class, last will be the largest for device class
            let lastIcon = iconFiles.lastObject as? String,
            let icon = UIImage(named: lastIcon) else {
                return nil
        }
        
        return icon
    }
}
