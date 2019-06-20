//
//  LoginViewController.swift
//  CasAngel
//
//  Created by Admin on 23/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        let email = self.view.viewWithTag(1) as! UITextField
        email.leftViewMode = .always
        email.leftView = UIImageView.init(image: UIImage.init(named: "account"))
        email.borderStyle = .roundedRect
        
        let pwd = self.view.viewWithTag(2) as! UITextField
        pwd.leftViewMode = .always
        pwd.leftView = UIImageView.init(image: UIImage.init(named: "lock"))
        pwd.borderStyle = .roundedRect
        
        let login = self.view.viewWithTag(3) as! UIButton
        login.layer.cornerRadius = 5
        login.addTarget(self, action: #selector(self.loginClicked), for: UIControl.Event.touchUpInside)
        
        let signup = self.view.viewWithTag(5) as! UITextView
        signup.isUserInteractionEnabled = true
        
        let tapSignup = UITapGestureRecognizer(target: self, action: #selector(self.signupClicked(_:)))
        signup.addGestureRecognizer(tapSignup)
    }
    
    @objc func loginClicked() {
        gotoViewController("ProfileViewController")
    }
    
    @objc func signupClicked(_ sender: UITapGestureRecognizer? = nil) {
        gotoViewController("SignupViewController")
    }
    
    func gotoViewController(_ withIdentifier: String) {
        let parent = self.parent
        
        self.view.removeFromSuperview()
        self.removeFromParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupView = storyboard.instantiateViewController(withIdentifier: withIdentifier)
        
        parent?.addChild(signupView)
        parent?.view.addSubview(signupView.view)
        
        signupView.didMove(toParent: parent)
    }
}
