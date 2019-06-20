//
//  StoreViewController.swift
//  CasAngel
//
//  Created by Admin on 24/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class CategoryViewCell: UICollectionViewCell {
    
}

class ProductViewCell: UICollectionViewCell {
    @IBOutlet var productNameView: UITextView? = nil
    @IBOutlet var productPriceView: UITextView? = nil
}

class CategoryAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var storeViewController: StoreViewController? = nil
    var categoryType: Int = 0
    var lastIndexPath: IndexPath? = nil
    var leftBtn: UIView? = nil
    var rightBtn: UIView? = nil
    
    let color = UIColor.init(rgb: 0xdaa94a)
    var tintColor = UIColor.init(rgb: 0xffffff)
    
    override init() {
        super.init()
    }
    
    func setStoreViewController(vc: StoreViewController) {
        self.storeViewController = vc
    }
    
    func setCategoryType(type: Int) {
        self.categoryType = type
    }
    
    func allLoaded() -> Bool {
        if storeViewController != nil && self.categoryType == 1 {
            return GlobalData.getPostCategories() != nil
        }
        return GlobalData.getCategories() != nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if storeViewController != nil && self.categoryType == 1 {
            return GlobalData.getPostCategories()?.count ?? 3
        }
        return GlobalData.getCategories()?.count ?? 3
    }
    
    func setTintColor(color: UIColor) {
        self.tintColor = color
    }
    
    func setImage(imageView: UIImageView, index: Int) -> String{
        if !allLoaded() {
            return "chair"
        }
        let category = GlobalData.getCategories()?[index]
        var urlStr = category?._image?._src!
        if storeViewController != nil && self.categoryType == 1 {
            let post_category = GlobalData.getPostCategories()?[index]
            urlStr = post_category?._description
            if urlStr == "" {
                return "chair"
            }
        }
        let url = URL(string: urlStr!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "chair")!
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: imageView.frame.size,
            radius: 20.0
        )
        
        imageView.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
                var iColor = self.tintColor
                if self.lastIndexPath?.item == index {
                    iColor = self.color
                }
                imageView.tintImageColor(color: iColor)
            })
        return category?._name! ?? "chair"
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category_cell", for: indexPath) as! CategoryViewCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        let txtView = cell.viewWithTag(2) as! UITextView
        let categoryName = self.setImage(imageView: imageView, index: indexPath.item)
        txtView.text = categoryName
        
        setImage(imageView: imageView, index: indexPath.item)
        if lastIndexPath == nil {
            lastIndexPath = collectionView.indexPathForItem(at: CGPoint.init(x: 0, y: 0))
        }
        if (lastIndexPath != nil && (lastIndexPath?.elementsEqual(indexPath))!) {
            //imageView.image = UIImage.init(named: "chair")?.imageWithColor(color1: color)
            imageView.tintImageColor(color: self.color)
            txtView.textColor = color
        }else {
            //imageView.image = UIImage.init(named: "chair")?.imageWithColor(color1: imageView.tintColor)
            imageView.tintImageColor(color: self.tintColor)
            txtView.textColor = self.tintColor
        }
        return cell
    }
    
    func animateCell(cell: UIView) {
        let transition: CATransition = CATransition.init()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.fade
        transition.repeatCount = 1
        cell.layer.add(transition, forKey: nil)
    }
    
    func selectAt(_ collectionView: UICollectionView, with indexPath: IndexPath) -> CategoryViewCell {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryViewCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        //imageView.image = UIImage.init(named: "chair")?.imageWithColor(color1: color)
        imageView.tintImageColor(color: color)
        let txtView = cell.viewWithTag(2) as! UITextView
        txtView.textColor = color
        return cell
    }
    
    func unselectAt(_ collectionView: UICollectionView, with indexPath: IndexPath) -> CategoryViewCell {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryViewCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        //imageView.image = UIImage.init(named: "chair")?.imageWithColor(color1: imageView.tintColor)
        imageView.tintImageColor(color: tintColor)
        let txtView = cell.viewWithTag(2) as! UITextView
        txtView.textColor = imageView.tintColor
        return cell
    }
    
    func updateButtons(_ cv: UICollectionView, with indexPath: IndexPath) {
        let x = indexPath.item
        let end = cv.numberOfItems(inSection: 0)
        if x > 3 {
            leftBtn?.alpha = 1
            leftBtn?.isUserInteractionEnabled = true
        } else {
            leftBtn?.alpha = 0
            leftBtn?.isUserInteractionEnabled = false
        }
        if x < end - 3 {
            rightBtn?.alpha = 1
            rightBtn?.isUserInteractionEnabled = true
        } else {
            rightBtn?.alpha = 0
            rightBtn?.isUserInteractionEnabled = false
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lastIndexPath != nil && indexPath.elementsEqual(lastIndexPath!) {
            return
        }
        let cell = selectAt(collectionView, with: indexPath)
        animateCell(cell: cell)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if lastIndexPath != nil && collectionView.cellForItem(at: lastIndexPath!) != nil {
            let cell = unselectAt(collectionView, with: lastIndexPath!)
            animateCell(cell: cell)
        }
        if lastIndexPath != nil {
            updateButtons(collectionView, with: lastIndexPath!)
        }
        lastIndexPath = indexPath
        if storeViewController != nil {
            storeViewController?.loadProducts()
        }
    }
}

class StoreViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var categoriesAdapter = CategoryAdapter()
    var categoriesView: UICollectionView? = nil
    var productsView: UICollectionView? = nil
    var leftBtn: UIButton? = nil
    var rightBtn: UIButton? = nil
    var products: [ProductDetails]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let catView = self.view.viewWithTag(1) as! UICollectionView
        categoriesView = catView
        catView.dataSource = categoriesAdapter
        catView.delegate = categoriesAdapter
        categoriesAdapter.lastIndexPath = catView.indexPathForItem(at: CGPoint.init(x: 0, y: 0))
        //categoriesAdapter.selectAt(catView, with: catView.indexPathForItem(at: CGPoint.init(x: 1, y: 0))!)
        categoriesAdapter.setStoreViewController(vc: self)
        loadProducts()
        
        productsView = self.view.viewWithTag(2) as! UICollectionView
        productsView?.dataSource = self
        productsView?.delegate = self
        
        leftBtn = self.view.viewWithTag(3) as! UIButton
        rightBtn = self.view.viewWithTag(4) as! UIButton
        categoriesAdapter.leftBtn = leftBtn
        categoriesAdapter.rightBtn = rightBtn
        leftBtn?.addTarget(self, action: #selector(self.onLeft(_:)), for: UIControl.Event.touchDown)
        rightBtn?.addTarget(self, action: #selector(self.onRight(_:)), for: UIControl.Event.touchDown)
    }
    
    func loadProducts() {
        if categoriesAdapter.categoryType == 1 {
            (self as! DesignWayViewController).loadPosts()
            return
        }
        if GlobalData.getCategories() == nil {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let idx = self.categoriesAdapter.lastIndexPath?.item
            let categoryId = GlobalData.getCategories()?[idx!]._id
            let params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("category", categoryId), ("page", "1"), ("per_page", 100))
            APIClient.getAllProducts(args: params, completionHandler: { (products: [ProductDetails]?, success: Bool) in
                if success {
                    self.products = products
                    self.productsView?.reloadData()
                }
            })
        })
    }
    
    func getCategoryType() -> Int {
        return 0
    }
    
    @objc func onLeft(_ rec: UIGestureRecognizer) {
        if categoriesView == nil {
            return
        }
        if categoriesAdapter.lastIndexPath != nil {
            if (categoriesAdapter.lastIndexPath?.item)! > 2{
                let prevItem = (categoriesAdapter.lastIndexPath?.item)! - 1
                let prevPath = IndexPath.init(item: prevItem, section: 0)
                categoriesView?.scrollToItem(at: prevPath, at: .centeredHorizontally, animated: true)
                categoriesAdapter.unselectAt(categoriesView!, with: categoriesAdapter.lastIndexPath!)
                categoriesAdapter.selectAt(categoriesView!, with: prevPath)
                categoriesAdapter.updateButtons(categoriesView!, with: categoriesAdapter.lastIndexPath!)
                categoriesAdapter.lastIndexPath = prevPath
            } else {
                leftBtn?.isUserInteractionEnabled = false
                let trans = CATransition.init()
                trans.duration = 0.1
                trans.type = .fade
                leftBtn?.layer.opacity = 0
                leftBtn?.layer.add(trans, forKey: nil)
            }
            if (categoriesAdapter.lastIndexPath?.item)! < ((categoriesView?.numberOfItems(inSection: 0))!) - 3 {
                rightBtn?.isUserInteractionEnabled = true
                let trans = CATransition.init()
                trans.duration = 0.1
                trans.type = .fade
                rightBtn?.layer.opacity = 1
                rightBtn?.layer.add(trans, forKey: nil)
            }
        }
    }
    
    @objc func onRight(_ rec: UIGestureRecognizer) {
        if categoriesView == nil {
            return
        }
        if categoriesAdapter.lastIndexPath != nil {
            if (categoriesAdapter.lastIndexPath?.item)! < ((categoriesView?.numberOfItems(inSection: 0))!) - 3 {
                let nextItem = (categoriesAdapter.lastIndexPath?.item)! + 1
                let nextPath = IndexPath.init(item: nextItem, section: 0)
                categoriesView?.scrollToItem(at: nextPath, at: .centeredHorizontally, animated: true)
                categoriesAdapter.unselectAt(categoriesView!, with: categoriesAdapter.lastIndexPath!)
                categoriesAdapter.selectAt(categoriesView!, with: nextPath)
                categoriesAdapter.updateButtons(categoriesView!, with: categoriesAdapter.lastIndexPath!)
                categoriesAdapter.lastIndexPath = nextPath
            } else {
                rightBtn?.isUserInteractionEnabled = false
                let trans = CATransition.init()
                trans.duration = 0.1
                trans.type = .fade
                rightBtn?.layer.opacity = 0
                rightBtn?.layer.add(trans, forKey: nil)
            }
            if (categoriesAdapter.lastIndexPath?.item)! > 2{
                leftBtn?.isUserInteractionEnabled = true
                let trans = CATransition.init()
                trans.duration = 0.1
                trans.type = .fade
                leftBtn?.layer.opacity = 1
                leftBtn?.layer.add(trans, forKey: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoriesAdapter.categoryType == 1 {
            return (self as! DesignWayViewController).posts?.count ?? 3
        }
        if products == nil {
            return 3
        } else {
            return products?.count ?? 3
        }
    }
    
    func setImage(imageView: UIImageView, index: Int) {
        var urlStr: String?
        
        if categoriesAdapter.categoryType == 1 {
            let posts = (self as! DesignWayViewController).posts
            if posts == nil {
                return
            }
            urlStr = posts?[index]._jetpack_featured_media_url
        } else {
            if products == nil {
                return
            }
            let product = products?[index]
            urlStr = product?._images?[0]._src! ?? ""
        }
        let url = URL(string: urlStr!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "chair")!
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: imageView.frame.size,
            radius: 20.0
        )
        
        imageView.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
                
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductViewCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        //imageView.image = UIImage.init(named: "shipping")
        setImage(imageView: imageView, index: indexPath.item)
        if categoriesAdapter.categoryType == 0 {
            cell.productNameView?.text = products?[indexPath.item]._name
            cell.productPriceView?.text = products?[indexPath.item]._price
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: 5)
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
