//
//  PhotoImageCell.swift
//  AssistMe
//
//  Created by Milla J. Vilkki on 11/19/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import Photos

class PhotoImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var requestID: PHImageRequestID?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
