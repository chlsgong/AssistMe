//
//  PhotoPickerViewController.swift
//  AssistMe
//
//  Created by Milla J. Vilkki on 11/19/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Photos
import UIKit

protocol PhotoPickerViewControllerDelegate: class {
    func didSelectImage(with data: Data, in viewController: PhotoPickerViewController)
}

class PhotoPickerViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate var cellSize: CGSize {
        let size = ((self.collectionView.frame.width - 10) / 3)
        return CGSize(width: size, height: size)
    }
    
    fileprivate var imageSize: CGSize {
        let scale = UIScreen.main.scale
        let size = cellSize.width * scale
        return CGSize(width: size, height: size)
    }
    
    fileprivate var assets: [PHAsset] = []
    fileprivate lazy var imageManager = PHCachingImageManager()
    
    weak var delegate: PhotoPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askPermission()
    }
    
    
    fileprivate func askPermission() {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.loadAssets()
                    self.collectionView.reloadData()
                } else {
                    let alert = UIAlertController.errorAlert(withMessage: "This application does not have access to your photos")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    fileprivate func loadAssets() {
        let assetCollection = PHAsset.fetchAssets(with: .image, options: nil)
        assets = assetCollection.objects(at: IndexSet(integersIn: NSRange(location: 0, length: assetCollection.count).toRange() ?? 0..<0))
        imageManager.startCachingImages(for: assets, targetSize: imageSize, contentMode: .aspectFill, options: nil)
    }
    
}

extension PhotoPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoImageCell", for: indexPath) as? PhotoImageCell else {
            return UICollectionViewCell()
        }
        
        if let requestID = cell.requestID {
            imageManager.cancelImageRequest(requestID)
        }
        
        cell.requestID = imageManager.requestImage(for: assets[indexPath.item], targetSize: imageSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
            cell.imageView.image = image
            cell.requestID = nil
        })
        
        return cell
    }
}

extension PhotoPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

extension PhotoPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = assets[indexPath.item]
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImageData(for: selectedAsset, options: options) { data, resultString, orientation, info in
            if let data = data {
                self.delegate?.didSelectImage(with: data, in: self)
            } else {
                //TODO: error, failed to load data
            }
        }
    }
}
