//
//  CreateSpaceViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class CreateSpaceViewController: StoreViewController {
    
    @IBOutlet var imageView: UIImageView? = nil
    @IBOutlet var productSampleView: DraggableImageView? = nil
    public var imagePath: String? = nil
    public var cameraPhoto: UIImage? = nil
    
    var lastPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backClicked(_:))
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hidePromptView), userInfo: nil, repeats: false)
        setImage()
    }
    
    func getThumbFileName() -> String {
        let date = Date()
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy_MM_dd_HH_mm"
        return "mythumb__" + dateFormatterPrint.string(from: date) + ".png"
    }
    
    @IBAction func saveSpace() {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
       
        let fileName = getThumbFileName()
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = self.imageView?.image?.pngData() {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print("file saved")
                } catch {
                    print("error saving file:", error)
                }
            }
        }
    }
    
    func setImage(iv: UIImageView, urlStr: String) {
        let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "camera_mock")!
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: (imageView?.frame.size)!,
            radius: 20.0
        )
        
        iv.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
        })
    }
    
    func setImage() {
        if imagePath == nil {
            if cameraPhoto != nil {
                self.imageView?.image = cameraPhoto
            }
            return
        }
        setImage(iv: self.imageView!, urlStr: self.imagePath!)
    }
    
    @objc func hidePromptView() {
        let transition: CATransition = CATransition.init()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.fade
        transition.repeatCount = 1
        let alertView = self.view.viewWithTag(10)
        alertView?.alpha = 0
        alertView?.layer.add(transition, forKey: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2
        cell?.layer.borderColor = UIColor.black.cgColor
        cell?.layer.cornerRadius = 5
        if lastPath != nil {
            collectionView.cellForItem(at: lastPath!)?.layer.borderWidth = 0
        }
        lastPath = indexPath
        
        DispatchQueue.main.async {
            self.productSampleView?.isHidden = false
            self.productSampleView?.layoutSubviews()
            if self.products != nil {
                self.setImage(iv: self.productSampleView!, urlStr: (self.products?[indexPath.item]._images?[0]._src)!)
            }else {
                self.productSampleView?.image = UIImage.init(named: "chair_example")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if lastPath != nil && indexPath.elementsEqual(lastPath!) {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.cornerRadius = 5
        } else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.cornerRadius = 5
        }
        return cell
    }
    
    @objc func backClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
