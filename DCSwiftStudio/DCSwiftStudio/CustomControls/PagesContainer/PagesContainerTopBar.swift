//
//  PagesContainerTopBar.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/1/9.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

protocol PagesContainerTopBarDelegate {
    
    /// 选中topBar的一项
    func topBarSelectedByIndex(index: Int)
    /// 重复点击topBar时会调用该方法
    func topBarSelectedAgainbyIndex(index: Int)
}

class PagesContainerTopBar: UIView {

    var bacImgView: UIImageView?
    var scrollView: UIScrollView?
    
    var cursor: UIView?
    var horiMargin: CGFloat = 0.0
    var cursorWidth: CGFloat = 0.0
    var cursorHeight: CGFloat = 1.5
    
    var buttonMargin: CGFloat = 20
    var seperateLineArr = [UIView]()
    var showSeperateLines: Bool = false
    var isButtonAlignmentLeft: Bool = false
    
    var buttonArr = [TopBarButton]()
    
    var selectedColor: UIColor = UIColor.red
    var normalColor: UIColor = UIColor.darkGray
    
    var delegate: PagesContainerTopBarDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.bacImgView = UIImageView.init(frame: self.bounds)
        self.addSubview(self.bacImgView!)
        
        self.scrollView = UIScrollView.init(frame: self.bounds)
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.bounces = false
        self.addSubview(self.scrollView!)
        
        self.cursor = UIView.init(frame: CGRect.zero)
        self.cursor?.backgroundColor = UIColor.red
        self.scrollView?.addSubview(self.cursor!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.frame.size
        self.scrollView?.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        self.bacImgView?.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        
        if self.buttonArr.count == 0 { return }
        
        var contenWidth = self.horiMargin * 2.0
        for i  in 0 ..< self.buttonArr.count {
            let button: UIButton = self.buttonArr[i]
            contenWidth += button.frame.size.width
        }
        
        /// 按钮未排满整屏时，是否所有按钮靠左
        if !self.isButtonAlignmentLeft && contenWidth < size.width {
            let buttonWidth = floorf(Float(size.width / CGFloat(self.buttonArr.count)))
            for button in self.buttonArr {
                var frame = button.frame
                frame.size.width = CGFloat(buttonWidth)
                button.frame = frame
            }
        }
        
        /// 设置按钮位置
        var selectedIndex: Int = 0
        var xOffset = self.horiMargin
        let buttonHeight = size.height
        for i in 0 ..< self.buttonArr.count {
            let button = self.buttonArr[i]
            var frame = button.frame
            frame.origin.x = xOffset
            frame.origin.y = 0
            frame.size.height = buttonHeight
            button.frame = frame
            xOffset += frame.size.width
            if button.isSelected {
                selectedIndex = i
            }
        }
        
        /// 设置分割线位置
        for i in 0 ..< self.seperateLineArr.count {
            
            let line = self.seperateLineArr[i]
            line.isHidden = !self.showSeperateLines
            
            let buttonPrev = self.buttonArr[i]
            let buttonNext = self.buttonArr[i + 1]
            
            let lineTop = self.frame.height / 5.0
            let lineHeight = self.frame.height - lineTop * 2.0
            let lineX = (buttonPrev.frame.maxX + buttonNext.frame.minX) / 2.0
            line.frame = CGRect.init(x: lineX, y: lineTop, width: 0.5, height: lineHeight)
        }
        
        self.scrollView?.contentSize = CGSize.init(width: xOffset + self.horiMargin, height: size.height)
        
        /// 设置游标位置
        let selectedButton = self.buttonArr[selectedIndex]
        let frame = selectedButton.frame
        
        selectedButton.titleLabel?.sizeToFit()
        let cursorWidth = self.cursorWidth == 0 ? selectedButton.titleLabel!.frame.size.width : self.cursorWidth
        self.cursor?.frame = CGRect.init(x: frame.origin.x + (frame.size.width - cursorWidth) / 2, y: frame.maxY - self.cursorHeight, width: cursorWidth, height: self.cursorHeight)
        
        /// 游标圆角
        self.cursor?.layer.cornerRadius = self.cursorHeight / 2.0
    }
    
    func updateConentWithTitles(titles: NSArray) {
        
        for button in self.buttonArr {
            button.removeFromSuperview()
        }
        for seperateLine in self.seperateLineArr {
            seperateLine.removeFromSuperview()
        }
        
        if titles.count == 0 { return }
        
        var tempArray = NSMutableArray.init()
        for i in 0 ..< titles.count {
            
            let title = titles[i]
            let button = self.createCustomButtonWithTitle(title: title as! NSString)
            button.tag = i
            button.sizeToFit()
            
            var frame = button.frame
            frame.size.width += self.buttonMargin
            button.frame = frame
            
            self.scrollView?.addSubview(button)
            tempArray.add(button)
        }
        self.buttonArr = NSMutableArray.init(array: tempArray) as! [TopBarButton]
        self.scrollView?.bringSubviewToFront(self.cursor!)
        self.setSelectedIndex(index: 0)
        
        tempArray = NSMutableArray.init()
        for _ in 0 ..< self.buttonArr.count - 1 {
            let line = UIView.init()
            line.backgroundColor = UIColor.lightGray
            self.scrollView?.addSubview(line)
            tempArray.add(line)
        }
        self.seperateLineArr = NSArray.init(array: tempArray) as! [UIView]
        
        self.setNeedsLayout()
    }
    
    func createCustomButtonWithTitle(title: NSString) -> UIButton {
        
        let button = TopBarButton.init()
        button.setTitle(title as String, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        button.normalColor = self.normalColor
        button.selectedColor = self.selectedColor
        button.setTitleColor(self.normalColor, for: UIControl.State.normal)
        button.setTitleColor(self.selectedColor, for: UIControl.State.selected)
        
        return button
    }
    
    @objc func buttonClicked(button: UIButton) {
        
        let tag = button.tag
        
        if let delegate = self.delegate {
            if button.isSelected {
                delegate.topBarSelectedAgainbyIndex(index: tag)
            }
            else {
                self.setSelectedIndex(index: tag)
                delegate.topBarSelectedByIndex(index: tag)
            }
        }
    }
    
    func setSelectedIndex(index: Int) {
        
        if index > self.buttonArr.count { return }
        
        for i in 0 ..< self.buttonArr.count {
            let button = self.buttonArr[i]
            button.isSelected = (i == index)
        }
        
        self.updateScrollViewPosition()
    }
    
    func getSelectedIndex() -> Int {
        
        var selectedIndex: Int = 0
        for i in 0 ..< self.buttonArr.count {
            let button = self.buttonArr[i]
            if button.isSelected {
                selectedIndex = button.tag
            }
        }
        return selectedIndex
    }
    
    func scrollRectToCenter(frame: CGRect) {
        
        let size = self.frame.size
        let contentSize = self.scrollView?.contentSize
        
        var targetX = frame.origin.x - (size.width - frame.size.width) / 2
        var targetEndX = targetX + size.width
        
        if targetX < 0 {
            targetX = 0
        }
        if targetEndX > contentSize!.width {
            targetEndX = contentSize!.width
        }
        let targetRect = CGRect.init(x: targetX, y: 0, width: targetEndX - targetX, height: frame.size.height)
        self.scrollView?.scrollRectToVisible(targetRect, animated: true)
    }
    
    func updateScrollViewPosition() {
        
        let size = self.frame.size
        let contentSize = self.scrollView?.contentSize
        
        if size.width >= contentSize!.width { return }
        
        var frame = CGRect.zero
        for i in 0 ..< self.buttonArr.count {
            let button = self.buttonArr[i]
            if button.isSelected {
                frame = button.frame
            }
        }
        self.scrollRectToCenter(frame: frame)
    }
    
    func setCursorPosition(percent: CGFloat) {
        
        let indexOffset = percent * CGFloat(self.buttonArr.count)
        let preIndex = Int(floorf(Float(indexOffset)))
        let nextIndex = Int(ceilf(Float(indexOffset)))
        
        if preIndex >= 0 && nextIndex <= self.buttonArr.count {
            let preBtn = self.buttonArr[preIndex]
            let nextBtn = self.buttonArr[nextIndex]
            
            var cursorWidth:CGFloat = self.cursorWidth
            if cursorWidth == 0 {
                cursorWidth = preBtn.titleLabel!.frame.size.width + (indexOffset - CGFloat(preIndex)) * (nextBtn.titleLabel!.frame.size.width - preBtn.titleLabel!.frame.size.width)
                var frame = self.cursor!.frame;
                frame.size.width = cursorWidth;
                self.cursor!.frame = frame;
            }
            
            let cursorCenterX = preBtn.center.x + (indexOffset - CGFloat(preIndex)) * (nextBtn.center.x - preBtn.center.x)
            self.cursor!.center = CGPoint.init(x: cursorCenterX, y: self.cursor!.center.y)
        }
    }
}

