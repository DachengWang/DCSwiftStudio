//
//  TopBarButton.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/1/9.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class TopBarButton: UIButton {

    let titleFontSize:CGFloat = 14.0
    
    @objc open var normalColor: UIColor = UIColor.black
    @objc open var selectedColor: UIColor = UIColor.red
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(normalColor, for: UIControl.State.normal)
        self.setTitleColor(selectedColor, for: UIControl.State.selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        
        willSet {
            
        }
        didSet {
            if isSelected {
                self.setTitleColor(selectedColor, for: UIControl.State.selected)
                self.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize, weight: UIFont.Weight.bold)
            }
            else {
                self.setTitleColor(normalColor, for: UIControl.State.normal)
                self.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize, weight: UIFont.Weight.thin)
            }
        }
    }
}
