//
//  KeyboardModelViewController.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/1/9.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class KeyboardModelViewController: ModelViewController {

    @objc public override init(hostController: UIViewController, animationCompletion: @escaping ModelViewAnimationCompletion) {
        super.init(hostController: hostController, animationCompletion: animationCompletion)
        
        NotificationCenter.default.addObserver(self, selector: #selector(__keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(__keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(__keyboardFrameWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func __keyboardWillShow(notification: Notification) {
        
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        self.keyboardWillShowWithHeight(keyboardHeight: keyboardHeight)
    }
    
    @objc func __keyboardWillHide(notification: Notification) {
        self.keyBoardWillHide()
    }
    
    func keyboardWillShowWithHeight(keyboardHeight: CGFloat) {
        
    }
    
    func keyBoardWillHide() {
        
    }
    
    @objc func __keyboardFrameWillChange(notification: Notification) {
        
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        self.keyboardFrameWillChange(keyboardHeight: keyboardHeight)
    }
    
    func keyboardFrameWillChange(keyboardHeight: CGFloat) {
        
    }
}
