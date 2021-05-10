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
    var numberCountTextField: UITextField!
//    var modeMaskView: UIView!
    
    var sortViews: Array<SortView> = []
    var sortViewHight: Array<Int> = []
    var sort: SortType! = BubbleSort()
    
    var numberCount: Int = 200
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
            return self.displayViewWidth / CGFloat(self.numberCount)
        }
    }
    
    
    
    

    public var type: SortTypeEnum?
    
    var countInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "VisibleSorts"
        self.view.backgroundColor = UIColor.yellow
        self.edgesForExtendedLayout = [UIRectEdge.left, UIRectEdge.right]
        
        var title: String?
        switch type {
        case .BubbleSort:
            title = "BubbleSort"
        case .SelectSort:
            title = "SelectSort"
        case .InsertSort:
            title = "InsertSort"
        case .ShellSort:
            title = "ShellSort"
        case .HeapSort:
            title = "HeapSort"
        case .MergeSort:
            title = "MergeSort"
        case .QuickSort:
            title = "QuickSort"
        default:
            title = "unknown"
        }
        self.title = title!
        
        self.initViews()
        self.setSortClosure()
    }
    

    func initViews() {
        
        let space: CGFloat = 10.0
        let height: CGFloat = 30.0
        let size: CGSize = self.view.frame.size
        
        let topView:UIView = UIView.init(frame: CGRect.init(x: space, y: space, width: size.width - space*2.0, height: height))
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        topView.layer.borderWidth = 0.5
        topView.layer.borderColor = UIColor.darkGray.cgColor
        topView.layer.cornerRadius = 3.0
        topView.clipsToBounds = true
        
        let countLabel:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 60.0, height: height));
        topView.addSubview(countLabel)
        countLabel.text = "元素个数："
        countLabel.sizeToFit()
        countLabel.center.y = height / 2.0
        
        numberCountTextField = UITextField.init(frame: CGRect.init(x: 60.0 + space*2.0, y: 0.0, width: topView.frame.size.width - space*4.0 - 60.0*2.0, height: height))
        numberCountTextField.backgroundColor = UIColor.lightGray
        numberCountTextField.autoresizingMask  = .flexibleWidth
        topView.addSubview(numberCountTextField)
        
        let actionButton: UIButton = UIButton.init(type: UIButton.ButtonType.system);
        actionButton.frame = CGRect.init(x: topView.frame.size.width - space - 60.0, y: 0.0, width: 60.0, height: height)
        actionButton.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        actionButton.setTitle("Action", for: UIControl.State.normal)
        actionButton.addTarget(self, action: #selector(actionBtnClicked(button:)), for: UIControl.Event.touchUpInside)
        topView.addSubview(actionButton)
        
        displayView = UIView.init(frame: CGRect.init(x: space, y: space*2.0 + height, width: size.width - space*2.0, height: size.height - space*3.0 - height))
        displayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        displayView.backgroundColor = UIColor.white
        self.view.addSubview(displayView)
    }
    
    
    @objc func actionBtnClicked(button: UIButton) {
        
//        self.modeMaskView.isHidden = false
        DispatchQueue.global().async {
            self.sortViewHight = self.sort.sort(items: self.sortViewHight)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.numberCountTextField.delegate = self
        self.numberCountTextField.text = "\(numberCount)"
        if sortViews.isEmpty {
            self.configSortViewHeight()
            self.addSortViews()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Response Event
    @IBAction func tapSegmentContol(_ sender: UISegmentedControl) {
        self.configSortViewHeight()
        for i in 0..<self.sortViews.count {
            self.updateSortViewHeight(index: i, value: CGFloat(sortViewHight[i]))
        }
        
        let sortType = SortTypeEnum(rawValue: sender.selectedSegmentIndex)!
        self.sort = SortFactory.create(type: sortType)
        self.setSortClosure()
    }
    
    @IBAction func tapSortButton(_ sender: AnyObject) {
//        self.modeMaskView.isHidden = false
        DispatchQueue.global().async {
            self.sortViewHight = self.sort.sort(items: self.sortViewHight)
        }
    }
    
    //MARK: -- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let text = textField.text
        guard let number: Int = Int(text!) else {
            return true
        }
        numberCount = number
        self.resetSubViews()
        return true
    }


    //MARK: - Private Method
    /// 设置排序对象相关的回调
    private func setSortClosure() {
        weak var weak_self = self
        sort.setEveryStepClosure(everyStepClosure: { (index, value) in
            DispatchQueue.main.async {
                weak_self?.updateSortViewHeight(index: index, value: CGFloat(value))
            }
        }) { (list) in
            DispatchQueue.main.async {
//                weak_self?.modeMaskView.isHidden = true
            }
        }
    }
    
    /// 随机生成sortView的高度
    private func configSortViewHeight() {
        if !sortViewHight.isEmpty {
            sortViewHight.removeAll()
        }
        for _ in 0..<self.numberCount {
            self.sortViewHight.append(Int(arc4random_uniform(UInt32(displayViewHeight))))
        }
    }
    
    private func addSortViews() {
        for i in 0..<self.numberCount {
            let size: CGSize = CGSize(width: self.sortViewWidth, height: CGFloat(sortViewHight[i]))
            let origin: CGPoint = CGPoint(x: CGFloat(i) * sortViewWidth, y: 0)
            let sortView = SortView(frame: CGRect(origin: origin, size: size))
            self.displayView.addSubview(sortView)
            self.sortViews.append(sortView)
            CGRect(origin: CGPoint.zero, size: CGSize())
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
