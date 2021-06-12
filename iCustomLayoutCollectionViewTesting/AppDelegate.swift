//
//  AppDelegate.swift
//  CustomLayoutCollectionViewTesting
//
//  Created by astroboy0803 on 2020/8/26.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
//        let navController = UINavigationController(rootViewController: CustomCollectionViewController())
//        window?.rootViewController = navController
        
        window?.rootViewController = CustomCollectionViewController(layoutConfigure: .average(2))
        
        window?.makeKeyAndVisible()
        
        return true
    }
}
