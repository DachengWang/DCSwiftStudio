//
//  SortsController.swift
//  DCSwiftStudio
//
//  Created by wangdacheng on 2021/5/10.
//  Copyright © 2021 大成小栈. All rights reserved.
//

import UIKit

class SortsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "VisibleSorts"
        self.view.backgroundColor = UIColor.yellow
        self.edgesForExtendedLayout = [UIRectEdge.left, UIRectEdge.right]
        
        self.initViews()
    }
    
    func initViews() {
        
        let space: CGFloat = 15.0
        let size: CGSize = self.view.frame.size
        
        let titleArr:NSArray = ["Bubble", "Select", "Insert", "Shell", "Heap", "Merge", "Quick"]
        
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
        
        let sortController: SortController = SortController.init()
        sortController.type = SortTypeEnum(rawValue: button.tag)!;
        self.navigationController?.pushViewController(sortController, animated: true)
    }
    

}
