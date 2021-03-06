//
//  CustomControlsController.swift
//  DCSwiftStudio
//
//  Created by wangdacheng on 2021/5/10.
//  Copyright © 2021 大成小栈. All rights reserved.
//

import UIKit

class CustomControlsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CustomControls"
        self.view.backgroundColor = .yellow
        self.edgesForExtendedLayout = [UIRectEdge.left, UIRectEdge.right]

        self.initViews();
    }
    

    func initViews() {
        
        let space: CGFloat = 15.0
        let size: CGSize = self.view.frame.size
        
        let titleArr:NSArray = ["角标按钮", "弹窗类控件", "滑动选择控件", "DrawSignture", "TestSwift"]
        
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
            let scriptBtnCon:SuperscriptBtnController = SuperscriptBtnController.init()
            self.navigationController?.pushViewController(scriptBtnCon, animated: true)
        }
        else if button.tag == 1 {
            let toggleController:ToggleController = ToggleController.init()
            self.navigationController?.pushViewController(toggleController, animated: true)
        }
        else if button.tag == 2 {
            let pagesContainer: PagesContainerController = PagesContainerController.init()
            self.navigationController?.pushViewController(pagesContainer, animated: true)
        }
        else if button.tag == 3 {
            let drawSignture: DrawSigntureController = DrawSigntureController.init()
            self.navigationController?.pushViewController(drawSignture, animated: true)
        }
        else if button.tag == 4 {
            let testSwift: TestSwiftController = TestSwiftController.init()
            self.navigationController?.pushViewController(testSwift, animated: true)
        }
        
    }
}
