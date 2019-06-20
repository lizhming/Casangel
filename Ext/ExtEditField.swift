//
//  ExtEditField.swift
//  CasAngel
//
//  Created by Admin on 23/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ExtEditField: UITextField {
    
    let padding = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).inset(by: padding)
    }
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return super.leftViewRect(forBounds: bounds).inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10))
    }
}
