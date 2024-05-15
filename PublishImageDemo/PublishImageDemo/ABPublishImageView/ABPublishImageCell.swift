//
//  ABPublishImageCell.swift
//  PublishDemo
//
//  Created by abin on 2024/5/15.
//

import UIKit

class ABPublishImageCell: UICollectionViewCell {
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func setupUI() {
        imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.abp_cornerRadius = 6
        contentView.addSubview(imageView)
        
        let btn = UIButton(frame: imageView.frame)
        btn.addAction(UIAction(handler: {[weak self] _ in
            guard let self = self else {return}
            showImageBrowser()
        }), for: .touchUpInside)
        
        contentView.addSubview(btn)
        
    }
    
    /// 预览图片
    func showImageBrowser() {
        guard ABCurrentWindow != nil else {
            return
        }
        let imageView = UIImageView(frame: ABCurrentWindow!.bounds)
        imageView.backgroundColor = .init(white: 0, alpha: 0.26)
        imageView.image = self.imageView.image
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        ABCurrentWindow?.addSubview(imageView)
    }
    
    @objc func imageTapped(gesture: UITapGestureRecognizer) {
        gesture.view?.removeFromSuperview()
    }
    
}
