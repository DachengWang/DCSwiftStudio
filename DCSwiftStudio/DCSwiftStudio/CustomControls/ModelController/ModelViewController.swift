//
//  ModelViewController.swift
//  QiCustomControls
//
//  Created by wangdacheng on 2020/1/7.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

@objc
public enum ModelViewDirection: Int {
    case Direction_Center
    case Direction_TopDown
    case Direction_LeftToRight
    case Direction_BottomUp
    case Direction_RightToLeft
}

public typealias ModelViewAnimationCompletion = (_ presentedController: AnyObject, _ presented: Bool, _ maskViewTapped: Bool) -> Void

open class ModelViewController: UIViewController {
    
    @objc open var hostController: UIViewController?
    @objc open var maskViewTapEnable: Bool = false
    @objc open var maskViewAlpha: CGFloat = 0.6
    @objc open var maskViewColor: UIColor = UIColor.darkGray
    @objc open var direction: ModelViewDirection = .Direction_Center
    @objc open var duration:CGFloat = 0.3
    
    internal var _animationCompletion: ModelViewAnimationCompletion?
    internal var _retainSelf: UIViewController?
    internal var _maskView: UIControl?
    internal var _hostView: UIView?
    internal var _presented: Bool = false
    internal var _maskViewTapped:Bool = false
    
    
    @objc public init(hostController: UIViewController, animationCompletion: @escaping ModelViewAnimationCompletion) {
        super.init(nibName: nil, bundle: nil)
        
        self.hostController = hostController
        
        _retainSelf = self
        _hostView = hostController.view
        _animationCompletion = animationCompletion
        _maskView = UIControl.init(frame: CGRect.init(x: 0, y: 0, width: _hostView!.bounds.width, height: _hostView!.bounds.height))
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ModelViewController deinit")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // default
        self.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 2 * 30, height: 300)
        self.view.backgroundColor = UIColor.white;
    }
    
    
    //MARK: - public methods
    
    @objc public func toggle() {
        
        guard self.hostController != nil else { return }
        
        self.allowUserInteraction(isAllow: false)
        _maskViewTapped = false
        
        if _presented {
            self.dismissWithMaskViewTapped(isTapped: false)
            self.allowBackSwipeGesture(isAllow: true)
        }
        else {
            self.hostController?.view.endEditing(true)
            self.allowBackSwipeGesture(isAllow: false)
            self.show()
        }
    }
    
    @objc public func cancel() {
        
        _presented = false
        _maskView?.alpha = 0.0
        self.view.alpha = 0.0
        
        _maskView?.removeFromSuperview()
        self.view.removeFromSuperview()
        
        self._retainSelf = nil
        self.endAppearanceTransition()
        self.allowUserInteraction(isAllow: true)
        self.allowBackSwipeGesture(isAllow: true)
    }
    
    
    //MARK: - private methods
    
    func show() {
        
        print("ModelViewController show")
        
        if !_presented {
            _presented = true
            self.handleMaskView()
            self.executeAnimationsForShow(isShow: true)
        }
    }
    
    func allowUserInteraction(isAllow: Bool) {
        
        if isAllow {
            if UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        else {
            if !UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }
    
    func allowBackSwipeGesture(isAllow: Bool) {
        
        if ((self.hostController as? UINavigationController) != nil) {
            let hostController: UINavigationController = self.hostController as! UINavigationController
            if hostController.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
                hostController.interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
    
    func executeAnimationsForShow(isShow: Bool) {
        
        weak var weakSelf = self
        
        if isShow {
            self.placeSelfViewBeforeAnimation()
            UIView.animate(withDuration: TimeInterval(self.duration), animations: {
                weakSelf?._maskView!.alpha = weakSelf!.maskViewAlpha;
                weakSelf?.placeSelfViewAfterAnimation()
            }) { _ in
                if weakSelf?._animationCompletion != nil {
                    weakSelf?._animationCompletion?(weakSelf!, true, weakSelf!._maskViewTapped)
                }
                weakSelf?.allowUserInteraction(isAllow: true)
            }
        }
        else {
            self.placeSelfViewAfterAnimation()
            UIView.animate(withDuration: TimeInterval(self.duration), animations: {
                weakSelf?._maskView!.alpha = 0.0;
                weakSelf?.view.alpha = 0.0;
                self.placeSelfViewBeforeAnimation()
            }) { _ in
                weakSelf?._maskView?.removeFromSuperview()
                weakSelf?.view.removeFromSuperview()
                weakSelf?.allowUserInteraction(isAllow: true)
                if weakSelf?._animationCompletion != nil {
                    weakSelf?._animationCompletion?(weakSelf!, false, weakSelf!._maskViewTapped)
                }
                weakSelf?._retainSelf = nil
                weakSelf?.endAppearanceTransition()
            }
        }
    }
    
    func handleMaskView() {
        
        _maskView?.backgroundColor = self.maskViewColor
        _maskView?.alpha = self.maskViewAlpha
        _hostView?.addSubview(_maskView!)
        _hostView?.addSubview(self.view)
        
        if self.maskViewTapEnable {
            _maskView?.addTarget(self, action: #selector(maskViewTapped(sender:)), for: UIControl.Event.touchUpInside)
        }
        else {
            _maskView?.removeTarget(self, action: #selector(maskViewTapped(sender:)), for: UIControl.Event.touchUpInside)
        }
        
        if let view = self.view {
            view.center = CGPoint.init(x: _hostView!.bounds.width / 2.0, y: _hostView!.bounds.height / 2.0)
            view.clipsToBounds = true
            view.alpha = 1.0
        }
    }
    
    @objc func maskViewTapped(sender: AnyObject) {
        
        self.dismissWithMaskViewTapped(isTapped: true)
    }
    
    func dismissWithMaskViewTapped(isTapped: Bool) {
        
        print("ModelViewController dismissWithMaskViewTapped:\(isTapped)")
        
        if _presented {
            _presented = false
            _maskViewTapped = isTapped
            self.executeAnimationsForShow(isShow: false)
        }
    }
    
    @discardableResult
    func placeSelfViewBeforeAnimation() -> CGPoint {
        
        switch self.direction {
            case ModelViewDirection.Direction_TopDown:
                self.view.frame = self.CGRectCenteredToRectAtTop(alignedRect: self.view.frame, toRect: _hostView!.bounds)
            case ModelViewDirection.Direction_LeftToRight:
                self.view.frame = self.CGRectCenteredToRectAtLeft(alignedRect: self.view.frame, toRect: _hostView!.bounds)
            case ModelViewDirection.Direction_BottomUp:
                self.view.frame = self.CGRectCenteredToRectAtBottom(alignedRect: self.view.frame, toRect: _hostView!.bounds)
            case ModelViewDirection.Direction_RightToLeft:
                self.view.frame = self.CGRectCenteredToRectAtRight(alignedRect: self.view.frame, toRect: _hostView!.bounds)
            default:
                break
        }
        
        return self.view.center
    }
    
    @discardableResult
    func placeSelfViewAfterAnimation() -> CGPoint {
        
        switch self.direction {
            case ModelViewDirection.Direction_TopDown:
                self.view.frame = self.CGRectCenteredInnerToRectAtTop(alignedRect: self.view.frame, toRect: _hostView!.bounds)
            case ModelViewDirection.Direction_LeftToRight:
                self.view.frame = self.CGRectCenteredInnerToRectAtLeft(alignedRect: self.view.frame, toRect: _hostView!.bounds)
            case ModelViewDirection.Direction_BottomUp:
                self.view.frame = self.CGRectCenteredInnerToRectAtBottom(alignedRect: self.view.frame, toRect: _hostView!.bounds)
            case ModelViewDirection.Direction_RightToLeft:
                self.view.frame = self.CGRectCenteredInnerToRectAtRight(alignedRect: self.view.frame, toRect: _hostView!.bounds)
            default:
                break
        }
        
        return self.view.center
    }
    
    //MARK: - Rect change methods
    
    func CGRectCenteredToRectAtTop(alignedRect: CGRect, toRect: CGRect) -> CGRect {
        
        let topLet:CGPoint = toRect.origin
        let newX = topLet.x - (alignedRect.width - toRect.width) / 2.0
        let newY = topLet.y - alignedRect.height
        
        return CGRect.init(x: newX, y: newY, width: alignedRect.width, height: alignedRect.height)
    }
    
    func CGRectCenteredToRectAtLeft(alignedRect: CGRect, toRect: CGRect) -> CGRect {
        
        let topLet:CGPoint = toRect.origin
        let newX = topLet.x - alignedRect.width
        let newY = topLet.y - (alignedRect.height - toRect.height) / 2.0
        
        return CGRect.init(x: newX, y: newY, width: alignedRect.width, height: alignedRect.height)
    }
    
    func CGRectCenteredToRectAtBottom(alignedRect: CGRect, toRect: CGRect) -> CGRect {
        
        let topLet:CGPoint = toRect.origin
        let newX = topLet.x - (alignedRect.width - toRect.width) / 2.0
        let newY = topLet.y + toRect.height
        
        return CGRect.init(x: newX, y: newY, width: alignedRect.width, height: alignedRect.height)
    }
    
    func CGRectCenteredToRectAtRight(alignedRect: CGRect, toRect: CGRect) -> CGRect {
        
        let topLet:CGPoint = toRect.origin
        let newX = topLet.x + toRect.width
        let newY = topLet.y - (alignedRect.height - toRect.height) / 2.0
        
        return CGRect.init(x: newX, y: newY, width: alignedRect.width, height: alignedRect.height)
    }
    
    
    func CGRectCenteredInnerToRectAtTop(alignedRect: CGRect, toRect: CGRect) -> CGRect {
        
        let topLet:CGPoint = toRect.origin
        let newX = topLet.x + (toRect.width - alignedRect.width) / 2.0
        let newY = topLet.y
        
        return CGRect.init(x: newX, y: newY, width: alignedRect.width, height: alignedRect.height)
    }
    
    func CGRectCenteredInnerToRectAtLeft(alignedRect: CGRect, toRect: CGRect) -> CGRect {
        
        let topLet:CGPoint = toRect.origin
        let newX = topLet.x
        let newY = topLet.y + (toRect.height - alignedRect.height) / 2.0
        
        return CGRect.init(x: newX, y: newY, width: alignedRect.width, height: alignedRect.height)
    }
    
    func CGRectCenteredInnerToRectAtBottom(alignedRect: CGRect, toRect: CGRect) -> CGRect {
        
        let topLet:CGPoint = toRect.origin
        let newX = topLet.x + (toRect.width - alignedRect.width) / 2.0
        let newY = topLet.y + toRect.height - alignedRect.height
        
        return CGRect.init(x: newX, y: newY, width: alignedRect.width, height: alignedRect.height)
    }
    
    func CGRectCenteredInnerToRectAtRight(alignedRect: CGRect, toRect: CGRect) -> CGRect {
        
        let topLet:CGPoint = toRect.origin
        let newX = topLet.x + toRect.width - alignedRect.width
        let newY = topLet.y + (toRect.height - alignedRect.height) / 2.0
        
        return CGRect.init(x: newX, y: newY, width: alignedRect.width, height: alignedRect.height)
    }
    
    
    func CGRectSetWidth(rect: CGRect, width: CGFloat) -> CGRect {
        
        return CGRect.init(x: rect.origin.x, y: rect.origin.y, width: width, height: rect.size.height)
    }
    
    func CGRectSetHeight(rect: CGRect, height: CGFloat) -> CGRect {
        
        return CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: height)
    }
}




