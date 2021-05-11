//
//  SortController.swift
//  DCSwiftStudio
//
//  Created by wangdacheng on 2021/5/10.
//  Copyright © 2021 大成小栈. All rights reserved.
//

import UIKit

class SortController: UIViewController, UITextFieldDelegate{
    
    var displayView: UIView!
    var countTextField: UITextField!
    var actionButton: UIButton!
    
    
    var sortViews: Array<SortView> = []
    var sortViewHight: Array<Int> = []
    public var sort: SortType! = BubbleSort()
    public var sortName: String? = "BubbleSort"
    
    var count: Int = 200
    var displayViewHeight: CGFloat {
        get {
            return displayView.frame.height
        }
    }
    
    var displayViewWidth: CGFloat {
        get {
            return displayView.frame.width
        }
    }
    
    var sortViewWidth: CGFloat {
        get {
            return self.displayViewWidth / CGFloat(self.count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = sortName
        self.view.backgroundColor = UIColor.yellow
        self.edgesForExtendedLayout = [UIRectEdge.left, UIRectEdge.right]
        
        self.initViews()
        self.setSortClosure()
        
    }
    
    func initViews() {
        
        let space: CGFloat = 5.0
        let height: CGFloat = 50.0
        let btnWidth: CGFloat = 70.0
        let size: CGSize = self.view.frame.size
        
        let topView:UIView = UIView.init(frame: CGRect.init(x: space, y: space, width: size.width - space*2.0, height: height))
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        
        let line:UIView = UIView.init(frame: CGRect.init(x: 0, y: height - 0.5, width: topView.frame.size.width, height: 1.0))
        line.backgroundColor = UIColor.lightGray
        topView.addSubview(line)
        
        let countLabel:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: btnWidth, height: height));
        countLabel.textColor = UIColor.darkGray
        topView.addSubview(countLabel)
        countLabel.text = "元素个数："
        countLabel.sizeToFit()
        countLabel.center.y = height / 2.0
        
        countTextField = UITextField.init(frame: CGRect.init(x: btnWidth + space*2.0, y: 0.0, width: topView.frame.size.width - space*4.0 - btnWidth*2.0, height: height))
        countTextField.autoresizingMask  = .flexibleWidth
        countTextField.placeholder = "输入count值，并回车"
        topView.addSubview(countTextField)
        
        actionButton = UIButton.init(type: UIButton.ButtonType.system);
        actionButton.frame = CGRect.init(x: topView.frame.size.width - space - btnWidth, y: 0.0, width: btnWidth, height: height)
        actionButton.setTitle("Action", for: UIControl.State.normal)
        actionButton.addTarget(self, action: #selector(actionBtnClicked(button:)), for: UIControl.Event.touchUpInside)
        topView.addSubview(actionButton)
        
        displayView = UIView.init(frame: CGRect.init(x: space, y: space*2.0 + height, width: size.width - space*2.0, height: size.height - space*3.0 - height))
        displayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        displayView.backgroundColor = UIColor.white
        self.view.addSubview(displayView)
        
        displayView.layer.borderWidth = 0.5
        displayView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.countTextField.delegate = self
        self.countTextField.text = "\(count)"
        if sortViews.isEmpty {
            self.configSortViewHeight()
            self.addSortViews()
        }
    }
    
    @objc func actionBtnClicked(button: UIButton) {
        
        self.view.endEditing(true)
        actionButton.isEnabled = false
        countTextField.isUserInteractionEnabled = false
        
        DispatchQueue.global().async {
            self.sortViewHight = self.sort.sort(items: self.sortViewHight)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    // MARK: -- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        let text = textField.text
        guard let number: Int = Int(text!) else {
            return true
        }
        count = number
        self.resetSubViews()
        return true
    }


    //MARK: - Private Method
    private func setSortClosure() {
        
        weak var weakSelf = self
        sort.setEveryStepClosure(everyStepClosure: { (index, value) in
            DispatchQueue.main.async {
                weakSelf?.updateSortViewHeight(index: index, value: CGFloat(value))
            }
        }) { (list) in
            DispatchQueue.main.async {
                weakSelf?.actionButton.isEnabled = true
                weakSelf?.countTextField.isUserInteractionEnabled = true
                //weak_self?.modeMaskView.isHidden = true
            }
        }
    }
    
    /// 随机生成sortView的高度
    private func configSortViewHeight() {
        if !sortViewHight.isEmpty {
            sortViewHight.removeAll()
        }
        for _ in 0..<self.count {
            self.sortViewHight.append(Int(arc4random_uniform(UInt32(displayViewHeight))))
        }
    }
    
    private func addSortViews() {
        for i in 0..<self.count {
            let size: CGSize = CGSize(width: self.sortViewWidth, height: CGFloat(sortViewHight[i]))
            let origin: CGPoint = CGPoint(x: CGFloat(i) * sortViewWidth, y: 0)
            let sortView = SortView(frame: CGRect(origin: origin, size: size))
            self.displayView.addSubview(sortView)
            self.sortViews.append(sortView)
        }
    }
    
    private func updateSortViewHeight(index: Int, value: CGFloat) {
        self.sortViews[index].updateHeight(height: value)
    }
    
    private func resetSubViews()  {
        for subView in self.sortViews  {
            subView.removeFromSuperview()
        }
        self.sortViews.removeAll()
        self.sortViewHight.removeAll()
        self.configSortViewHeight()
        self.addSortViews()
    }
    
    
}
