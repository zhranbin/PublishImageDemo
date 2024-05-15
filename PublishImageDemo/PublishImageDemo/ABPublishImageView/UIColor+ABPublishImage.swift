//
//  UIColor+ABPublishImage.swift
//  PublishDemo
//
//  Created by abin on 2024/5/15.
//

import UIKit

extension UIColor {
    
    /// 十六进制颜色
    /// - Parameter hexColor: 十六进制数
    /// - Returns: 颜色
    static func abp_hexColor(_ hexColor: Int, alpha: Double = 1) -> UIColor! {
        let color = UIColor(red: ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0,
                            green: ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0,
                            blue: ((CGFloat)(hexColor & 0xFF)) / 255.0,alpha: alpha)
        return color
    }
}
