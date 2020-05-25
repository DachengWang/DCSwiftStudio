//
//  SuperscriptBtn.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/3/16.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class ScriptLabelView: UIView {

    var scriptHeight: CGFloat = 30.0
    var contentView: UIView = UIView.init()
    private var scriptLabel: UILabel = UILabel.init()
    
    var roateMatrix: CGAffineTransform = CGAffineTransform.identity
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        contentView = UIView.init()
        contentView.backgroundColor = UIColor.red
        self.addSubview(contentView)
        
        contentView.layer.borderColor = UIColor.green.cgColor
        contentView.layer.borderWidth = 1.0
        
        scriptLabel = UILabel.init()
        scriptLabel.backgroundColor = UIColor.clear
        
        scriptLabel.font = UIFont.systemFont(ofSize: 12)
        scriptLabel.adjustsFontSizeToFitWidth = true
        scriptLabel.textColor = UIColor.white
        scriptLabel.textAlignment = .center
        contentView.addSubview(scriptLabel)
        
        scriptLabel.layer.borderColor = UIColor.yellow.cgColor
        scriptLabel.layer.borderWidth = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.frame.size
        let offset = sin(.pi / 4.0) * scriptHeight / 2.0
        let contentViewWidth = sqrt(2.0 * size.width * size.height)
        
        contentView.bounds = CGRect.init(x: 0, y: 0, width: contentViewWidth, height: scriptHeight)
        print("---->> \(contentView.frame)")
        
        contentView.center = CGPoint.init(x: size.width / 2.0 + offset, y: size.height / 2.0 - offset)
        contentView.transform = CGAffineTransform.init(rotationAngle: .pi / 4.0)
        
        scriptLabel.frame = CGRect.init(x: scriptHeight, y: 0, width: contentViewWidth - scriptHeight * 2.0, height: scriptHeight)
    }
    
    func setScriptText(text: String) {
        
        
        if text.lengthOfBytes(using: .utf8) > 0 {
            self.isHidden = false
            scriptLabel.text = text
        }
        else {
            self.isHidden = true
        }
    }
    
    func setScriptBackColor(backColor: UIColor, textColor: UIColor) {
        
        contentView.backgroundColor = backColor
        scriptLabel.textColor = textColor
    }
}
