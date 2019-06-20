//
//  DraggableImageView.swift
//  CasAngel
//
//  Created by Admin on 26/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class DraggableImageView: UIImageView {
    
    @IBOutlet var container: UIView? = nil
    
    var panGesture = UIPanGestureRecognizer()
    let topLeft = UIView()
    let topRight = UIView()
    let topMiddle = UIView()
    let rightMiddle = UIView()
    let bottomMiddle = UIView()
    let cancel = UIImageView()
    let okay = UIImageView()
    let border = UIView()
    
    func initWithIcon(_ view: UIView, with image: String) {
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 0
        view.frame.size = CGSize.init(width: 20, height: 20)
        view.layer.cornerRadius = 10
        let iv = view as! UIImageView
        iv.image = UIImage.init(named: image)
        view.isUserInteractionEnabled = true
        view.isHidden = self.isHidden
        container?.addSubview(view)
    }
    
    func initSubView(_ view: UIView) {
        view.backgroundColor = UIColor.black
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.clear.cgColor
        view.isUserInteractionEnabled = true
        view.isHidden = self.isHidden
        container?.addSubview(view)
    }
    
    func initCorners() {
        let sz = CGSize.init(width: 10, height: 10)
        let sz1 = CGSize.init(width: 20, height: 20)
        let x0: CGFloat = self.frame.origin.x - sz.width/2
        let y0: CGFloat = self.frame.origin.y - sz.height/2
        let x1 = x0 + self.frame.width + sz.width/2
        let y1 = y0 + self.frame.height + sz.height/2
        border.frame = CGRect.init(x: x0, y: y0, width: x1-x0, height: y1-y0)
        topLeft.frame = CGRect.init(origin: CGPoint.init(x: x0, y: y0), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        topRight.frame = CGRect.init(origin: CGPoint.init(x: x1, y: y0), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        topMiddle.frame = CGRect.init(origin: CGPoint.init(x: (x0+x1)/2, y: y0), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        rightMiddle.frame = CGRect.init(origin: CGPoint.init(x: x1, y: (y0+y1)/2), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        bottomMiddle.frame = CGRect.init(origin: CGPoint.init(x: (x0+x1)/2, y: y1), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        cancel.frame = CGRect.init(origin: CGPoint.init(x: x0, y: y1), size: sz1).offsetBy(dx: -sz1.width/2, dy: -sz1.height/2)
        okay.frame = CGRect.init(origin: CGPoint.init(x: x1, y: y1), size: sz1).offsetBy(dx: -sz1.width/2, dy: -sz1.height/2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 0
        layer.masksToBounds = false
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        
        initCorners()
        
        initSubView(border)
        border.backgroundColor = UIColor.clear
        border.layer.borderWidth = 2
        border.layer.borderColor = UIColor.black.cgColor
        initSubView(topLeft)
        topLeft.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(self.draggedCorner(_:))))
        initSubView(topRight)
        topRight.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(self.draggedCorner(_:))))
        initSubView(topMiddle)
        topMiddle.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(self.draggedCorner(_:))))
        initSubView(rightMiddle)
        rightMiddle.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(self.draggedCorner(_:))))
        initSubView(bottomMiddle)
        bottomMiddle.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(self.draggedCorner(_:))))
        initWithIcon(cancel, with: "cancel")
        initWithIcon(okay, with: "okay")
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func draggedCorner(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view)
        var sx: CGFloat = 1.0
        var sy: CGFloat = 1.0
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        print("dragged corner", sx, sy)
        var sdx: CGFloat = 0
        var sdy: CGFloat = 0
        var anchor = CGPoint.init(x: 0.5, y: 0.5)
        if sender.view == self.topLeft {
            sdx = self.frame.width - translation.x
            sdy = self.frame.height - translation.y
            anchor = CGPoint.init(x: 1, y: 1)
        } else if sender.view == self.topRight {
            sdx = self.frame.width + translation.x
            sdy = self.frame.height - translation.y
            anchor = CGPoint.init(x: 0, y: 1)
        } else if sender.view == self.topMiddle {
            sdy = self.frame.height - translation.y
            sdx = self.frame.width
            anchor = CGPoint.init(x: 0.5, y: 1)
        } else if sender.view == self.rightMiddle {
            sdx = self.frame.width + translation.x
            sdy = self.frame.height
            anchor = CGPoint.init(x: 0, y: 0.5)
        } else if sender.view == self.bottomMiddle {
            sdx = self.frame.width
            sdy = self.frame.height + translation.y
            anchor = CGPoint.init(x: 0.5, y: 0)
        }
        if sdx < 0 || sdy < 0 {
            return
        }
        sx = sdx/self.frame.width
        sy = sdy/self.frame.height
        let scaledTransform = self.transform.scaledBy(x: sx, y: sy)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: dx, y: dy)
        self.transform = scaledAndTranslatedTransform
        let orign = self.frame.origin
        let size = self.frame.size
        self.transform = .identity
        self.frame.origin = orign
        self.frame.size = size
        
        initCorners()
        let senderView = sender.view!
        senderView.center = CGPoint(x: senderView.center.x + translation.x, y: senderView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: sender.view)
        //})
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.bringSubviewToFront(self)
        let translation = sender.translation(in: self)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self)
        initCorners()
    }
}
