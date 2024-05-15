//
//  ViewController.swift
//  PublishImageDemo
//
//  Created by abin on 2024/5/15.
//

import UIKit

class ViewController: UIViewController {

    var images: [UIImage] = []
    private var editorIndexPath: IndexPath?
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 16, y: ABStatusBarHeight + 2, width: 36, height: 40))
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        return btn
    }()
    
    lazy var publishBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: ABScreenWidth - 16 - 60, y: ABStatusBarHeight + 2, width: 60, height: 40))
        btn.setTitle("发表", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var scrollerView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: publishBtn.frame.maxY + 2, width: ABScreenWidth, height: ABScreentHeight - publishBtn.frame.maxY - 2))
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var selectImageView: ABPublishImageView = {
        let view = ABPublishImageView(frame: CGRect(x: 16, y: 10, width: ABScreenWidth - 32, height: 0))
        view.imagesDidChangedCallback = {
            print("图片改变")
            print("图片张数 - \(view.images.count)")
            print("height - \(view.abp_height)")
        }
//        // 不设置会走内置的选择图片逻辑
//        view.addImageClickCallback = {
//            if let image = UIImage(systemName: "plus") {
//                return [image, image, image, image]
//            }
//            return []
//        }
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "123") {
            images.append(image)
        }
        view.addSubview(cancelBtn)
        view.addSubview(publishBtn)
        view.addSubview(scrollerView)
        scrollerView.addSubview(selectImageView)
    }


}



