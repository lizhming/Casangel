//
//  ProfileViewController.swift
//  CasAngel
//
//  Created by Admin on 24/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        
        let viewMyCreations = self.view.viewWithTag(21)
        viewMyCreations?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.myCreationsClicked(_:))))
        let viewOrders = self.view.viewWithTag(22)
        viewOrders?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.ordersClicked(_:))))
    }
    
    @objc func myCreationsClicked(_ sender: UIGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let taController = appDelegate.window?.rootViewController as! CustomTabBarController
        taController.animateToTab(toIndex: CustomTabBarController.TabIndex.TabIndexMyCreations.rawValue)
    }
    
    @objc func ordersClicked(_ sender: UIGestureRecognizer) {
        
    }
}
