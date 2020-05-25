//
//  SuperscriptButton.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/3/17.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class SuperscriptButton: UIButton {

    var scriptView = ScriptLabelView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(scriptView)
        
        scriptView.layer.borderColor = UIColor.blue.cgColor
        scriptView.layer.borderWidth = 2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.frame.size
        let scriptWidth:CGFloat = 100.0 // 要求是一个正方形
        scriptView.frame = CGRect.init(x: size.width - scriptWidth, y: 0, width: scriptWidth, height: scriptWidth)
    }
    
    func setScriptText(text: String) {
        
        scriptView.setScriptText(text: text)
    }
    
}
