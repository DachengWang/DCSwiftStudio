//
//  ToggleController.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/1/16.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class ToggleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "弹窗类控件"
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = [UIRectEdge.left, UIRectEdge.right]
        
        self.initViews()
    }

    func initViews() {
        
        let space: CGFloat = 15.0
        let size: CGSize = self.view.frame.size
        
        let titleArr:NSArray = ["alertView", "actionSheet"]
        
        var offset:CGFloat = 50.0
        
        for i in 0 ..< titleArr.count {
            let button = UIButton.init(type: UIButton.ButtonType.system)
            button.frame = CGRect.init(x: space, y: offset, width: size.width - space * 2.0, height: 50.0)
            button.addTarget(self, action:#selector(buttonClicked(button:)), for: UIControl.Event.touchUpInside)
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.setTitle(titleArr.object(at: i) as? String, for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            self.view.addSubview(button)
            
            button.tag = i
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 5
            
            offset = offset + CGFloat(50) + space
        }
    }

    @objc func buttonClicked(button: UIButton) {
        
        if button.tag == 0 {
//            let alertController = ModelViewController.init(hostController: self.navigationController!) { (modelController, presented, maskViewTapped) in
//
//                if !presented {
//
//                }
//            }
//            alertController.maskViewColor = UIColor.darkGray
//            alertController.direction = ModelViewDirection.Direction_Center
//            alertController.maskViewTapEnable = true
//            alertController.maskViewAlpha = 0.5
//            alertController.toggle()
            
            let alertController = AlertViewController.init(hostController: self.navigationController!) { (modelController, presented, maskViewTapped) in
                
                if !presented {
                    
                }
            }
            alertController.maskViewColor = UIColor.darkGray
            alertController.direction = ModelViewDirection.Direction_Center
            alertController.maskViewTapEnable = true
            alertController.maskViewAlpha = 0.5
            alertController.toggle()
        }
        else if button.tag == 1 {
            let actionSheet = ActionSheetViewController.init(hostController: self.navigationController!) { (actionSheet, presented, maskViewTapped) in
                
            }
            actionSheet.maskViewColor = UIColor.darkGray
            actionSheet.direction = ModelViewDirection.Direction_BottomUp
            actionSheet.maskViewTapEnable = true
            actionSheet.maskViewAlpha = 0.5
            actionSheet.toggle()
        }
        
    }
    

}
