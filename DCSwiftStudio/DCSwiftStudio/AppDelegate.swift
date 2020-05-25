//
//  AppDelegate.swift
//  DCSwiftStudio
//
//  Created by wangdacheng on 2020/5/25.
//  Copyright © 2020 大成小栈. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc: ViewController = ViewController.init()
        let nav: UINavigationController = UINavigationController.init(rootViewController: vc)
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

