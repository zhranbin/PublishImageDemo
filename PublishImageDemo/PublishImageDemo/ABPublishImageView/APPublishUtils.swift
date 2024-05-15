//
//  APPublishUtils.swift
//  PublishDemo
//
//  Created by abin on 2024/5/15.
//

import UIKit

/// 屏幕宽
let ABScreenWidth = UIScreen.main.bounds.size.width

/// 屏幕高
let ABScreentHeight = UIScreen.main.bounds.size.height

/// 状态栏高度
let ABStatusBarHeight = getStatusBarHeight()
func getStatusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 0.0
    if #available(iOS 13.0, *){
        if #available(iOS 13.0, *){
            let statusBarManager:UIStatusBarManager = UIApplication.shared.windows.first!.windowScene!.statusBarManager!
            statusBarHeight = statusBarManager.statusBarFrame.size.height
        }
        else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}

/// 底部安全距离
let ABBottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0

/// 顶部的安全距离
let ABTopSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0


/// 当前窗口
var ABCurrentWindow: UIWindow? {
    if #available(iOS 13.0, *) {
        if let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first{
            return window
        }else if let window = UIApplication.shared.delegate?.window{
            return window
        }else{
            return nil
        }
    } else {
        if let window = UIApplication.shared.delegate?.window{
            return window
        }else{
            return nil
        }
    }
}

/// 当前显示的viewcontroller
var ABCurrentViewController: UIViewController? {
    get {
        return currentViewController()
    }
}

/// 找到当前显示的viewcontroller
/// - Parameter base: base
/// - Returns: viewcontroller
private func currentViewController(base: UIViewController? = ABCurrentWindow?.rootViewController) -> UIViewController? {
    
    if let nav = base as? UINavigationController {
        return currentViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        return currentViewController(base: tab.selectedViewController)
    }
    if let presented = base?.presentedViewController {
        return currentViewController(base: presented)
    }
    if let split = base as? UISplitViewController{
        return currentViewController(base: split.presentingViewController)
    }
    return base
}

