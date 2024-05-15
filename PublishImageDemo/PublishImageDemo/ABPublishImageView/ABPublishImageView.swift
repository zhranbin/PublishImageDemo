//
//  ABPublishImageView.swift
//  PublishDemo
//
//  Created by abin on 2024/5/15.
//

import UIKit

class ABPublishImageView: UIView {

    var images: [UIImage] = [] {
        didSet {
            refreshFrame()
            collectionView.reloadData()
            imagesDidChangedCallback?()
        }
    }
    // 最多几张图片
    var maxImageNum: Int = 9
    // 图片之间间距
    var space: CGFloat = 6
    // 图片改变回调
    var imagesDidChangedCallback: (() -> Void)?
    // 点击添加图片的回调（自定义实现选择图片的逻辑）不设置采用默认的选择图片方式
    var addImageClickCallback: (() -> [UIImage])?
    
    private var editorIndexPath: IndexPath?
    private var pickerVC = UIImagePickerController()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ABPublishImageCell.self, forCellWithReuseIdentifier: "ABPublishImageCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.clipsToBounds = false
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGesture)
        return collectionView
    }()
    
    private lazy var addImageBtn: UIButton = {
        let W: CGFloat = (abp_width - space*2)/3
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: W, height: W))
        btn.backgroundColor = .init(white: 0.9, alpha: 0.8)
        btn.tintColor = .gray
        btn.abp_cornerRadius = 6
        let image = UIImage(systemName: "plus")
        let imv = UIImageView(frame: CGRect(x: 0, y: 0, width: W*0.6, height: W*0.6))
        imv.image = image
        imv.center = CGPoint(x: W/2, y: W/2)
        imv.backgroundColor = .clear
        btn.addSubview(imv)
        btn.addAction(UIAction(handler: {[weak self] _ in
            guard let self = self else {return}
            if self.addImageClickCallback != nil {
                let addImages = self.addImageClickCallback!()
                if addImages.count == 0 { return }
                let needNum = self.maxImageNum - self.images.count
                if addImages.count > needNum {
                    images.append(contentsOf: Array(addImages.prefix(needNum)))
                } else {
                    images.append(contentsOf: addImages)
                }
                
            } else {
                self.imageEditorAction()
            }
            
        }), for: .touchUpInside)
        return btn
    }()
    
    private lazy var deleteImageView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: ABScreentHeight - ABBottomSafeAreaHeight - 44, width: ABScreenWidth, height: ABBottomSafeAreaHeight + 44))
        view.backgroundColor = .abp_hexColor(0xDF3B30)
        return view
    }()
    
    private lazy var deleteImageViewTitleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: deleteImageView.bounds.width, height: 44))
        label.textAlignment = .center
        label.textColor = .white
        label.text = "拖入这里删除"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.addSubview(addImageBtn)
        deleteImageView.addSubview(deleteImageViewTitleLabel)
        refreshFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func refreshFrame() {
        let W: CGFloat = (abp_width - space*2)/3
        collectionView.abp_height = CGFloat((images.count >= maxImageNum ? images.count-1 : images.count)/3 + 1) * (W + space)
        self.abp_height = collectionView.abp_height
        addImageBtn.isHidden = images.count >= maxImageNum
        addImageBtn.frame = CGRect(x: CGFloat(images.count%3) * (W + space), y: CGFloat(images.count/3) * (W + space), width: addImageBtn.frame.width, height: addImageBtn.frame.height)
    }
    

}

extension ABPublishImageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ABPublishImageCell", for: indexPath) as! ABPublishImageCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.insertSubview(addImageBtn, at: 0)
    }
    

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let W: CGFloat = (abp_width - space*2)/3
        return CGSize(width: W, height: W)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return space // 设置行之间的间距
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return space // 设置列之间的间距
        }
    

    // MARK: Drag and Drop Reordering
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            editorIndexPath = selectedIndexPath
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            ABCurrentWindow?.addSubview(deleteImageView)
//            deleteImageView.isHidden = false
//            publishView.isHidden = true
            deleteImageView.backgroundColor = .abp_hexColor(0xDF3B30)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            let location = gesture.location(in: ABCurrentWindow!)
            if location.y >= ABScreentHeight - 80 {
                if deleteImageViewTitleLabel.text == "拖入这里删除" {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                deleteImageViewTitleLabel.text = "松手可以删除"
                deleteImageView.backgroundColor = .abp_hexColor(0xAF3B30)
            } else {
                deleteImageViewTitleLabel.text = "拖入这里删除"
                deleteImageView.backgroundColor = .abp_hexColor(0xDF3B30)
            }
        case .ended:
            // 获取拖动结束时的位置
            let endLocation = gesture.location(in: ABCurrentWindow!)
            // 如果拖动结束位置在屏幕最底部，删除图片
            if endLocation.y >= ABScreentHeight - 80 {
                if let selectedIndexPath = editorIndexPath {
                    // 删除图片
                    images.remove(at: selectedIndexPath.item)
                }
            }
            
            collectionView.endInteractiveMovement()
            editorIndexPath = nil
            deleteImageView.removeFromSuperview()
        default:
            collectionView.cancelInteractiveMovement()
            deleteImageView.removeFromSuperview()
        }
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        // 最后一个cell不可移动
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var newImages = images
        let movedPhoto = newImages.remove(at: sourceIndexPath.item)
        newImages.insert(movedPhoto, at: destinationIndexPath.item)
        images = newImages
    }
}



// MARK: 图片选择
extension ABPublishImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imageEditorAction() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 添加一个取消按钮
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let action1 = UIAlertAction(title: "从手机相册选择", style: .default) { (action) in
            self.chooseImage(sourceType: .photoLibrary)
        }
        alertController.addAction(action1)
        let action2 = UIAlertAction(title: "拍照", style: .default) { (action) in
            self.chooseImage(sourceType: .camera)
        }
        alertController.addAction(action2)
        ABCurrentViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private func chooseImage(sourceType: UIImagePickerController.SourceType) {
        pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = .white
        pickerVC.delegate = self
        pickerVC.allowsEditing = false
        pickerVC.sourceType = sourceType
        ABCurrentViewController?.present(pickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(image)
        }
        picker.dismiss(animated: true)
        
    }
    
    
}
