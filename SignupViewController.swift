//
//  SignupViewController.swift
//  CasAngel
//
//  Created by Admin on 23/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = self.view.viewWithTag(20) as! UIScrollView
        scrollView.contentSize = CGSize.init(width: scrollView.frame.width, height: 800)
        
        let login = self.view.viewWithTag(15) as! UITextView
        login.isUserInteractionEnabled = true
        
        let tapLogin = UITapGestureRecognizer(target: self, action: #selector(self.loginClicked(_:)))
        login.addGestureRecognizer(tapLogin)
        
        addLeftView(tag: 1, icon: "person")
        addLeftView(tag: 2, icon: "person")
        addLeftView(tag: 3, icon: "account")
        addLeftView(tag: 4, icon: "email")
        addLeftView(tag: 5, icon: "person")
        addLeftView(tag: 6, icon: "lock")
        addLeftView(tag: 7, icon: "location")
        addLeftView(tag: 8, icon: "location")
        addLeftView(tag: 9, icon: "location")
        addLeftView(tag: 10, icon: "person_android")
    }
    
    func addLeftView(tag: Int, icon: String) {
        let field = self.view.viewWithTag(tag) as! UITextField
        field.leftViewMode = .always
        field.leftView = UIImageView.init(image: UIImage.init(named: icon))
    }
    
    @objc func loginClicked(_ sender: UITapGestureRecognizer? = nil) {
        let parent = self.parent
        
        self.view.removeFromSuperview()
        self.removeFromParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupView = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        parent?.addChild(signupView)
        parent?.view.addSubview(signupView.view)
        
        signupView.didMove(toParent: parent)
    }
}
