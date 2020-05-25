//
//  PagesContainerController.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/1/9.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

class PagesContainerController: UIViewController, PagesContainerDataSource, PagesContainerDelegate {
    
    var titleArr: NSArray? = NSArray.init()
    var viewArr: NSArray? = NSArray.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "滑动选择控件"
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = [UIRectEdge.left, UIRectEdge.right]
        
        titleArr = ["000", "555555", "6666666666", "7", "8888888888888", "tttttt", "000", "555555", "6666666666", "7", "8888888888888", "tttttt"]
        
        let tempArr = NSMutableArray.init()
        for _ in 0 ..< titleArr!.count {
            let view = UIView.init()
            view.layer.borderWidth = 2.5
            view.layer.borderColor = UIColor.green.cgColor
            tempArr.add(view)
        }
        viewArr = NSArray.init(array: tempArr)
        
        let pagesContainer: PagesContainer = PagesContainer.init(frame: self.view.bounds)
        pagesContainer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        pagesContainer.setTitleColor(normalColor: UIColor.blue, selectedColor: UIColor.red)
        //pagesContainer.setShowSeperateLines(showSeperateLines: true)
        //pagesContainer.setShowSeperateLines(showSeperateLines: true)
        pagesContainer.setCursorColor(color: UIColor.systemBlue)
        pagesContainer.setCursorHeight(height: 2.5)
        pagesContainer.dataSource = self
        pagesContainer.delegate = self
        self.view.addSubview(pagesContainer)
        
        pagesContainer.layer.borderWidth = 1.0
        pagesContainer.layer.borderColor = UIColor.red.cgColor
    }
    
    
    func numberOfPages(in pagesContainer: PagesContainer) -> Int {
        
        return self.titleArr!.count
    }
    
    func pagesContainder(pagesContainder: PagesContainer, titleAt index: Int) -> String {
        
        let title: String = self.titleArr![index] as! String
        return title
    }
    
    func pagesContainder(pagesContainder: PagesContainer, viewAt index: Int) -> UIView {
        
        let view: UIView = self.viewArr![index] as! UIView
        return view
    }
    
    func pagesContainder(pagesContainder: PagesContainer, selectedByIndex index: Int) {
        
        print("pagesContainder selectedByIndex: \(index)")
    }
    
    func pagesContainder(pagesContainder: PagesContainer, selectedAgainByIndex index: Int) {
        
        print("pagesContainder selectedAgainByIndex: \(index)")
    }
    
}
