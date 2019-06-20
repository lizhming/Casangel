//
//  AppDelegate.swift
//  CasAngel
//
//  Created by Admin on 21/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootTabController: UITabBarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadInitialData()
        return true
    }
    
    func loadInitialData() {
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let params = Parameters(dictionaryLiteral: ("lang", "en-US"))
            APIClient.getAllCategories(args: params, completionHandler: { (categories: [CategoryDetails]?, success: Bool) in
                if success {
                    GlobalData.setCategories(categories: categories)
                }
            })
        })
    }
}

