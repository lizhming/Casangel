//
//  DesignWayViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DesignWayViewController: StoreViewController {
    
    var posts: [PostDetails]? = nil
    var lastSelected: IndexPath? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsView = self.view.viewWithTag(2) as! UICollectionView
        self.categoriesAdapter.setCategoryType(type: 1)
        self.categoriesAdapter.tintColor = UIColor.black
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            //params["parent"] = "328" //parent category id of tempate categories is 328
            let params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("parent", "328"))
            APIClient.getPostCategories(args: params, completionHandler: { (categories: [PostCategory]?, success: Bool) in
                if success {
                    GlobalData.setPostCategories(categories: categories)
                    self.loadPosts()
                    DispatchQueue.main.async {
                        self.categoriesView?.reloadData()
                    }
                }
            })
        })
        categoriesAdapter.setStoreViewController(vc: self)
        
    }
    
    func loadPosts() {
        if GlobalData.getPostCategories() == nil {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let idx = self.categoriesAdapter.lastIndexPath?.item
            let postCategoryId = GlobalData.getPostCategories()?[idx!]._id
            let params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("categories", postCategoryId), ("page", "1"), ("per_page", 100), ("embed", "true"))
            APIClient.getAllPosts(args: params, completionHandler: { (posts: [PostDetails]?, success: Bool) in
                if success {
                    self.posts = posts
                    DispatchQueue.main.async {
                        self.productsView?.reloadData()
                    }
                }
            })
        })
    }
    
    override func setImage(imageView: UIImageView, index: Int) {
        if self.posts == nil {
            return
        }
        let post = posts?[index]
        let urlStr = post?._jetpack_featured_media_url
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateSpace" {
            let vc = segue.destination as! UINavigationController
            if lastSelected != nil {
                let url = posts?[(lastSelected?.item)!]._jetpack_featured_media_url
                let csvc = vc.visibleViewController as! CreateSpaceViewController
                csvc.imagePath = url
            }
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lastSelected = indexPath
        self.performSegue(withIdentifier: "ShowCreateSpace", sender: self)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
