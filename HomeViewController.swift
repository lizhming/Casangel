//
//  FirstViewController.swift
//  CasAngel
//
//  Created by Admin on 21/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var gesture = UILongPressGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(rgb: 0x444242)
        let titleView = self.navigationItem.titleView
        titleView?.backgroundColor = UIColor.init(rgb: 0x444242)
        
        let cv: UIScrollView = self.view.subviews.first as! UIScrollView
        let fr = (cv.subviews.first?.frame)!
        cv.contentSize = CGSize.init(width: fr.width, height: fr.height)
        
        for tag in 1 ... 5 {
            let imageView = self.view.viewWithTag(tag) as! UIImageView
            let gesture = UITapGestureRecognizer (target: self, action: #selector(self.handleTap(_:)))
            gesture.cancelsTouchesInView = false
            imageView.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer? = nil) {
        // handle touch down and touch up events separately
        let iv = sender?.view as! UIImageView
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let taController = appDelegate.window?.rootViewController as! CustomTabBarController
        if iv.tag == 3 {
            taController.animateToTab(toIndex: CustomTabBarController.TabIndex.TabIndexIdeas.rawValue)
        } else if iv.tag == 5 {
            taController.animateToTab(toIndex: CustomTabBarController.TabIndex.TabIndexMyCreations.rawValue)
        } else if iv.tag == 4 {
            performSegue(withIdentifier: "ShowTrends", sender: self)
        } else if iv.tag == 1 {
            performSegue(withIdentifier: "ShowCamera", sender: self)
        } else if iv.tag == 2 {
            performSegue(withIdentifier: "ShowDesignWay", sender: self)
        }
    }
    
    func switchToDataTab(){
        
    }
    
    func switchToStoreTab(){
    }
}

