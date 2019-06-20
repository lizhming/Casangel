//
//  IdeasViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class IdeasCatAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cat_cell", for: indexPath)
        var color = UIColor.darkGray
        if indexPath.item % 3 == 2 {
            color = UIColor.lightGray
        } else if indexPath.item % 3 == 1 {
            color = UIColor.gray
        } else {
            color = UIColor.darkGray
        }
        cell.viewWithTag(1)?.backgroundColor = color
        return cell
    }
    
}


class IdeasViewContoller: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var catAdapter = IdeasCatAdapter()
    
    override func viewDidLoad() {
        let catView = self.view.viewWithTag(1) as! UICollectionView
        catView.dataSource = catAdapter
        catView.delegate = catAdapter
        
        let ideasView = self.view.viewWithTag(2) as! UICollectionView
        ideasView.dataSource = self
        ideasView.delegate = self
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: 5)
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
