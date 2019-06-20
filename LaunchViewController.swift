//
//  SecondViewController.swift
//  CasAngel
//
//  Created by Admin on 21/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // "Main" is name of .storybord file "
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        // "MiniGameView" is the ID given to the ViewController in the interfacebuilder
        // MiniGameViewController is the CLASS name of the ViewController.swift file acosiated to the ViewController
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "RootViewController")
        present(viewController, animated: true, completion: nil)
    }


}

