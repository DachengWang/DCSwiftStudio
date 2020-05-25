//
//  PagesContainer.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/1/9.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

protocol PagesContainerDataSource {
    /// Page的总数量
    func numberOfPages(in pagesContainer: PagesContainer) -> Int
    /// 获取某个title
    func pagesContainder(pagesContainder: PagesContainer, titleAt index: Int) -> String
    /// 获取某个view
    func pagesContainder(pagesContainder: PagesContainer, viewAt index: Int) -> UIView
}

protocol PagesContainerDelegate {
    /// 选中某个index
    func pagesContainder(pagesContainder: PagesContainer, selectedByIndex index: Int)
    /// 二次选中某个index
    func pagesContainder(pagesContainder: PagesContainer, selectedAgainByIndex index: Int)
}

class PagesContainer: UIView, UIScrollViewDelegate, PagesContainerTopBarDelegate {
    
    var topBarHeight: CGFloat = 35.0
    var topBar: PagesContainerTopBar = PagesContainerTopBar()
    
    let scrollView: UIScrollView = UIScrollView()
    let bottomLine: UIView = UIView()
    
    var currentSelectedIndex: Int = 0
    var titleArr = [NSString]()
    var viewArr = [UIView]()
    
    var dataSource: PagesContainerDataSource?
    var delegate: PagesContainerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.bottomLine.frame = CGRect.zero
        self.bottomLine.backgroundColor = UIColor.lightGray
        self.addSubview(self.bottomLine)
        
        self.topBar.frame = CGRect.zero
        self.topBar.delegate = self
        self.addSubview(self.topBar)
        
        self.scrollView.frame = CGRect.zero
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.scrollsToTop = false
        self.scrollView.alwaysBounceVertical = false
        self.scrollView.alwaysBounceHorizontal = false
        self.scrollView.bounces = false
        self.addSubview(self.scrollView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.frame.size
        let scrollViewHeight = size.height - self.topBarHeight
        self.topBar.frame = CGRect.init(x: 0, y: 0, width: size.width, height: self.topBarHeight)
        self.bottomLine.frame = CGRect.init(x: 0, y: self.topBarHeight - 0.5, width: size.width, height: 0.5)
        self.scrollView.frame = CGRect.init(x: 0, y: self.topBarHeight, width: size.width, height: scrollViewHeight)
        
        for i in 0 ..< self.viewArr.count {
            let view = self.viewArr[i]
            view.frame = CGRect.init(x: CGFloat(i) * size.width, y: 0, width: size.width, height: scrollViewHeight)
        }
        self.scrollView.contentSize = CGSize.init(width: size.width * CGFloat(self.viewArr.count), height: scrollViewHeight)
    }
    
    override func didMoveToSuperview() {
        
        self.reloadData()
    }
    
    func reloadData() {
        
        self.currentSelectedIndex = 0
        for view in self.viewArr {
            view.removeFromSuperview()
        }
        
        let tViewArr = NSMutableArray.init()
        let tTitleArr = NSMutableArray.init()
        let count: Int = (self.dataSource?.numberOfPages(in: self))!
        for i in 0 ..< count {
            let view = self.dataSource?.pagesContainder(pagesContainder: self, viewAt: i)
            view?.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
            tViewArr.add(view as Any)
            let title = self.dataSource?.pagesContainder(pagesContainder: self, titleAt: i)
            tTitleArr.add(title as Any)
            self.scrollView.addSubview(view!)
        }
        
        self.viewArr = NSArray.init(array: tViewArr) as! [UIView]
        self.titleArr = NSArray.init(array: tTitleArr) as! [NSString]
        self.topBar.updateConentWithTitles(titles: self.titleArr as NSArray)
        
        self.layoutSubviews()
    }
    
    
    //MARK: -  UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.width > 0 {
            self.topBar.setCursorPosition(percent: self.scrollView.contentOffset.x / self.scrollView.contentSize.width)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageIndex = Int(scrollView.contentOffset.x / self.scrollView.frame.size.width)
        if pageIndex != self.currentSelectedIndex {
            self.currentSelectedIndex = pageIndex
            self.topBar.setSelectedIndex(index: pageIndex)
            self.notifyDelegateSelectedIndex(index: pageIndex)
        }
    }
    
    
    //MARK: - PagesContainerTopBarDelegate
    
    func topBarSelectedByIndex(index: Int) {
        
        if index < self.viewArr.count {
            self.currentSelectedIndex = index
            
            self.scrollView.setContentOffset(CGPoint.init(x: CGFloat(index) * self.scrollView.frame.size.width, y: 0), animated: true)
            self.notifyDelegateSelectedIndex(index: index)
        }
    }
    
    func topBarSelectedAgainbyIndex(index: Int) {
        
        if index < self.viewArr.count {
            self.currentSelectedIndex = index
            self.scrollView.setContentOffset(CGPoint.init(x: CGFloat(index) * self.scrollView.frame.size.width, y: 0), animated: true)
            
            if let delegate = self.delegate {
                delegate.pagesContainder(pagesContainder: self, selectedAgainByIndex: index)
            }
        }
    }
    
    func notifyDelegateSelectedIndex(index: Int) {
        
        if let delegate = self.delegate {
            delegate.pagesContainder(pagesContainder: self, selectedByIndex: index)
        }
    }
    
    
    //MARK: -  设置、获取selectedPageIndex和pageView
    
    func setDefaultSelectedPageIndex(index: Int) {
        
        if index >= 0 && index <= self.viewArr.count && index != self.currentSelectedIndex {
            self.topBar.setSelectedIndex(index: index)
            self.topBarSelectedByIndex(index: index)
        }
    }
    
    func getCurrentPageIndex() -> Int {
        
        return self.topBar.getSelectedIndex()
    }
    
    func getCurrentPageView() -> UIView {
        
        return self.viewArr[self.topBar.getSelectedIndex()]
    }
    
    func getPageViewByIndex(index: Int) -> UIView? {
        
        if index < self.viewArr.count {
            return self.viewArr[index]
        }
        else {
            return nil
        }
    }
    
    
    //MARK: -  设置topBar风格样式
    
    func setCursorWidth(width: CGFloat) {
        
        self.topBar.cursorWidth = width
    }
    
    func setCursorHeight(height: CGFloat) {
        
        self.topBar.cursorHeight = height
    }
    
    func setCursorColor(color: UIColor) {
        
        self.topBar.cursor?.backgroundColor = color
    }
    
    func setButtonMargin(margin: CGFloat) {
        
        self.topBar.buttonMargin = margin
    }
    
    func setIsButtonAlignmentLeft(isAlignmentLeft: Bool) {
        
        self.topBar.isButtonAlignmentLeft = isAlignmentLeft
    }
    
    func setShowSeperateLines(showSeperateLines: Bool) {
        
        self.topBar.showSeperateLines = showSeperateLines
    }
    
    func setTitleColor(normalColor nColor: UIColor, selectedColor sColor: UIColor) {
        
        self.topBar.normalColor = nColor
        self.topBar.selectedColor = sColor
    }
}

