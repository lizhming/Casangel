//
//  VerticalLayout.swift
//  CasAngel
//
//  Created by Admin on 22/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class VerticalLayout: UIView {
    
    var yOffsets: [CGFloat] = []
    
    init(width: CGFloat) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var height: CGFloat = 0
        
        for i in 0..<subviews.count {
            let view = subviews[i] as UIView
            view.layoutSubviews()
            height += yOffsets[i]
            view.frame.origin.y = height
            height += view.frame.height
        }
        self.frame.size.height = height
    }
    
    override func addSubview(_ view: UIView) {
        
        yOffsets.append(view.frame.origin.y)
        super.addSubview(view)
        
    }
    
    func removeAll() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        yOffsets.removeAll(keepingCapacity: false)
        
    }
    
}
