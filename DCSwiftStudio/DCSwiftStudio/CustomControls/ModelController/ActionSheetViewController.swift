//
//  ActionSheetViewController.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/1/9.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class ActionSheetViewController: ModelViewController {

    let btnTitles: NSArray = ["111", "222", "333", "444", "555"]
    var clickedIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rowHeight: CGFloat = 40.0
        let size = self.view.frame.size
        
        for i in 0 ..< btnTitles.count {
            let btnTitle = btnTitles[i]
            let button = UIButton.init(type: UIButton.ButtonType.system)
            button.frame = CGRect.init(x: 0, y: rowHeight * CGFloat(i), width: size.width, height: rowHeight)
            button.addTarget(self, action: #selector(buttonCicked(button:)), for: UIControl.Event.touchUpInside)
            button.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth]
            button.setTitle(btnTitle as? String, for: UIControl.State.normal)
            button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
            self.view.addSubview(button)
            button.tag = i
        }
        self.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: rowHeight * CGFloat(btnTitles.count))
    }
    
    @objc func buttonCicked(button: UIButton) {
        
        self.clickedIndex = button.tag
        self.toggle()
    }
    
}
