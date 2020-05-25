//
//  AlertViewController.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/1/9.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class AlertViewController: KeyboardModelViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 15.0
        let rowHeight: CGFloat = 40.0
        var size = self.view.frame.size
        
        let titleLabel: UILabel = UILabel.init()
        titleLabel.frame = CGRect.init(x: space, y: space, width: size.width - space * 2.0, height: 30)
        titleLabel.autoresizingMask = [.flexibleWidth]
        titleLabel.textAlignment = .center
        titleLabel.text = "AlertTitle"
        self.view.addSubview(titleLabel)
        
        let textField: UITextField = UITextField.init()
        textField.frame = CGRect.init(x: space, y: titleLabel.frame.maxY + space, width: size.width - space * 2.0, height: 40)
        textField.autoresizingMask = [.flexibleWidth]
        textField.placeholder = "请输入..."
        self.view.addSubview(textField)
        
        let cancelBtn = UIButton.init(type: UIButton.ButtonType.system)
        cancelBtn.frame = CGRect.init(x: 0, y: textField.frame.maxY + space * 1.5, width: size.width / 2.0, height: rowHeight)
        cancelBtn.addTarget(self, action: #selector(buttonCicked(button:)), for: UIControl.Event.touchUpInside)
        cancelBtn.autoresizingMask = [.flexibleWidth, .flexibleRightMargin]
        cancelBtn.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        cancelBtn.setTitle("NO", for: UIControl.State.normal)
        self.view.addSubview(cancelBtn)
        cancelBtn.tag = 0
        
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.red.cgColor
        
        let verifyBtn = UIButton.init(type: UIButton.ButtonType.system)
        verifyBtn.frame = CGRect.init(x: cancelBtn.frame.maxX, y: textField.frame.maxY + space * 1.5, width: size.width / 2.0, height: rowHeight)
        verifyBtn.addTarget(self, action: #selector(buttonCicked(button:)), for: UIControl.Event.touchUpInside)
        verifyBtn.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        verifyBtn.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        verifyBtn.setTitle("YES", for: UIControl.State.normal)
        self.view.addSubview(verifyBtn)
        verifyBtn.tag = 1
        
        verifyBtn.layer.borderWidth = 1.0
        verifyBtn.layer.borderColor = UIColor.red.cgColor
        
        self.view.layer.cornerRadius = 5.0
        self.view.layer.masksToBounds = true
        self.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 40.0 * 2.0, height: verifyBtn.frame.maxY)
        
        size = self.view.frame.size
        
        var line = UIView.init(frame: CGRect.init(x: 0, y: textField.frame.maxY + space * 1.5, width: size.width, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        self.view.addSubview(line)
        
        line = UIView.init(frame: CGRect.init(x: size.width / 2, y: textField.frame.maxY + space * 1.5, width: 0.5, height: rowHeight))
        line.backgroundColor = UIColor.lightGray
        self.view.addSubview(line)
    }
    
    @objc func buttonCicked(button: UIButton) {
        
        self.toggle()
    }
    
    override func keyboardWillShowWithHeight(keyboardHeight: CGFloat) {
        
        let size = self.hostController?.view.frame.size
        self.view.center = CGPoint.init(x: self.view.center.x, y: (size!.height - keyboardHeight) / 2.0)
    }
    
    override func keyBoardWillHide() {
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25) {
            let size = weakSelf!.hostController?.view.frame.size
            weakSelf!.view.center = CGPoint.init(x: weakSelf!.view.center.x, y: size!.height / 2.0)
        }
    }
    
    override func keyboardFrameWillChange(keyboardHeight: CGFloat) {
        
        let size = self.hostController?.view.frame.size
        self.view.center = CGPoint.init(x: self.view.center.x, y: (size!.height - keyboardHeight) / 2.0)
    }
}
