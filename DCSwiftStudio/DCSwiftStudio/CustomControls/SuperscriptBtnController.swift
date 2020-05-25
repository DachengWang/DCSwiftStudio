//
//  SuperscriptBtnController.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/3/16.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class SuperscriptBtnController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "角标按钮"
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = [UIRectEdge.left, UIRectEdge.right]
        
        self.initViews()
    }
    
    func initViews() {
        
        let size = self.view.frame.size;
        
        let scriptBtn: SuperscriptButton = SuperscriptButton.init(type: UIButton.ButtonType.system)
        scriptBtn.frame = CGRect.init(x: (size.width - 200) / 2.0, y: 100.0, width: 200, height: 150)
        scriptBtn.addTarget(self, action: #selector(scriptBtnClicked(button:)), for: UIControl.Event.touchUpInside)
        scriptBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        scriptBtn.setTitle("Button", for: UIControl.State.normal)
        scriptBtn.setScriptText(text: "全场8折")
        self.view.addSubview(scriptBtn)
        
        scriptBtn.layer.borderColor = UIColor.lightGray.cgColor
        scriptBtn.layer.borderWidth = 1.0;
    }
    
    @objc func scriptBtnClicked(button: UIButton) {
        
        let alert: UIAlertController = UIAlertController.init(title: "提示", message: nil, preferredStyle: UIAlertController.Style.alert)
        let cancelAction:UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.navigationController!.present(alert, animated: true, completion: nil)
    }
    
}
