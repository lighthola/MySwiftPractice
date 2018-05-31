//
//  UIImage+Extension.swift
//  ClockInOutTodayExtension
//
//  Created by Bevis Chen on 2018/5/30.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func imageWithColor(_ tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
