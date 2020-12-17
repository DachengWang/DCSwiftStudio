//
//  DrawSigntureController.swift
//  DCSwiftStudio
//
//  Created by wangdacheng on 2020/10/20.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class DrawSigntureController: UIViewController {

    var imageView: UIImageView!
    var signatureView:DrawSignatureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DrawSignture"
        self.view.backgroundColor = .yellow
        self.edgesForExtendedLayout = [UIRectEdge.left, UIRectEdge.right, UIRectEdge.bottom]

        self.initViews()
    }
    
    func initViews() {
        
        let drawFrame = self.view.bounds
        let size = drawFrame.size
        
        let margin: Double = 15.0
        let buttonHeight: Double = 50.0
        let buttonLength = (Double(size.width) - margin*4) / 3.0
        
        let previewButton:UIButton = UIButton.init(type: UIButton.ButtonType.system)
        previewButton.frame = CGRect.init(x: margin, y: 0, width: buttonLength, height: buttonHeight)
        previewButton.addTarget(self, action: #selector(previewSignature), for: UIControl.Event.touchUpInside)
        previewButton.setTitle("预览", for: UIControl.State.normal)
        self.view.addSubview(previewButton)
        
        let reButton:UIButton = UIButton.init(type: UIButton.ButtonType.system)
        reButton.frame = CGRect.init(x: margin*2 + buttonLength, y: 0, width: buttonLength, height: buttonHeight)
        reButton.addTarget(self, action: #selector(reSignature), for: UIControl.Event.touchUpInside)
        reButton.setTitle("重签", for: UIControl.State.normal)
        self.view.addSubview(reButton)
        
        let saveButton:UIButton = UIButton.init(type: UIButton.ButtonType.system)
        saveButton.frame = CGRect.init(x: margin*3 + buttonLength*2, y: 0, width: buttonLength, height: buttonHeight)
        saveButton.addTarget(self, action: #selector(saveSignature), for: UIControl.Event.touchUpInside)
        saveButton.setTitle("保存", for: UIControl.State.normal)
        self.view.addSubview(saveButton)
        
        signatureView = DrawSignatureView(frame: CGRect.init(x: 0, y: buttonHeight, width: Double(size.width), height: Double(size.height) - buttonHeight))
        signatureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(signatureView)
        
        signatureView.layer.borderColor = UIColor.blue.cgColor
        signatureView.layer.masksToBounds = true
        signatureView.layer.borderWidth = 2.0
    }
    
    @objc func previewSignature() {
        
        let margin: Double = 15.0
        let size = self.signatureView.frame.size
        
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: Double(size.width) / 2.0, height: Double(size.height) / 2.0))
        imageView.backgroundColor = UIColor.yellow
        imageView.layer.borderColor = UIColor.yellow.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderWidth = 5.0
        self.view.addSubview(imageView)
        self.imageView.center = self.signatureView.center
        
        let signature = self.signatureView.getSignature()
        imageView.image = signature
        
        UIView.animate(withDuration: 0.3) {
            self.imageView.frame = CGRect.init(x: margin, y: margin, width: Double(size.width) - margin*2, height: Double(size.height) - margin*2)
            self.imageView.center = self.signatureView.center
        }
    }
    
    @objc func reSignature() {
        
        if self.imageView != nil {
            UIView.animate(withDuration: 0.3) {
                self.imageView.frame = CGRect.zero
                self.imageView.center = self.signatureView.center
            } completion: { (Bool) in
                self.imageView.image = nil
                self.imageView.removeFromSuperview()
                self.signatureView.clearSignature()
            }
        }
        else {
            self.signatureView.clearSignature()
        }
    }
    
    @objc func saveSignature() {
        
        let signature = self.signatureView.getSignature()
        UIImageWriteToSavedPhotosAlbum(signature, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        self.signatureView.clearSignature()
    }
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {

        if error != nil {
            print("签名保存失败");
        } else {
            print("签名保存成功");
        }
    }
}
