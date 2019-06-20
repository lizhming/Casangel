//
//  MyCreationViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CreationCell: UICollectionViewCell {
    @IBOutlet var nameTextView: UITextView? = nil
    @IBOutlet var dateTextView: UITextView? = nil
    @IBOutlet var imageView: UIImageView? = nil
}

class NewCreationCell: UICollectionViewCell {
    @IBOutlet var newButton: UIButton? = nil
}

class MyCreationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var thumbFiles: [URL]? = nil
    var currentSelectedImage: UIImage? = nil
    @IBOutlet var collectionView: UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionView = self.view.viewWithTag(1) as! UICollectionView?
        collectionView?.dataSource = self
        collectionView?.delegate = self
        loadThumbFiles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cc = thumbFiles?.count
        loadThumbFiles()
        if (thumbFiles?.count)! > cc! {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func loadThumbFiles() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)// if you want to filter the directory contents you can do like this:
            thumbFiles = directoryContents.filter{ $0.pathExtension == "png" }
            print("png urls:",thumbFiles)
        } catch {
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if thumbFiles != nil {
            return (thumbFiles?.count)! + 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellName = ""
        print (indexPath)
        if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1 {
            cellName = "new_creation_cell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! NewCreationCell
            return cell
        }else {
            cellName = "creation_cell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! CreationCell
            let fileName = thumbFiles?[indexPath.item].lastPathComponent
            let nameAndDate = fileName?.components(separatedBy: "__")
            if nameAndDate?.count == 2 {
                cell.nameTextView?.text = nameAndDate?[0]
                cell.dateTextView?.text = nameAndDate?[1]
            }
            let path = (thumbFiles?[indexPath.item].path)!
            print(path)
            cell.imageView?.image = UIImage.init(contentsOfFile: path)
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let createSpaceController = navController.visibleViewController as! CreateSpaceViewController
        createSpaceController.cameraPhoto = currentSelectedImage
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! CreationCell
        self.currentSelectedImage = cell.imageView?.image
        self.performSegue(withIdentifier: "ShowCreateSpace", sender: self)
    }
}
