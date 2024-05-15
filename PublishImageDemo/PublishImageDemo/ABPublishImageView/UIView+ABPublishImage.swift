//
//  UIView+ABPublishImage.swift
//  PublishDemo
//
//  Created by abin on 2024/5/15.
//

import UIKit

extension UIView {
    
    
    // MARK: - frame相关
    
    /// 尺寸
    var abp_size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            self.frame.size = CGSize(width: newValue.width, height: newValue.height)
        }
    }
    
    /// 宽度
    var abp_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            self.frame.size.width = newValue
        }
    }
    
    /// 高度
    var abp_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            self.frame.size.height = newValue
        }
    }
    
    /// 横坐标
    var abp_x: CGFloat {
        get {
            return self.frame.minX
        }
        set(newValue) {
            self.frame = CGRect(x: newValue, y: abp_y, width: abp_width, height: abp_height)
        }
    }
    
    /// 纵坐标
    var abp_y: CGFloat {
        get {
            return self.frame.minY
        }
        set(newValue) {
            self.frame = CGRect(x: abp_x, y: newValue, width: abp_width, height: abp_height)
        }
    }
    
    /// 右端横坐标
    var abp_right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set(newValue) {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    /// 底端纵坐标
    var abp_bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set(newValue) {
            frame.origin.y = newValue - frame.size.height
        }
    }
    
    // MARK: xib
    @IBInspectable var abp_cornerRadius: CGFloat {
        get{
            self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
}
