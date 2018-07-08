//
//  CameraRollCollectionViewCell.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/30.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import Photos

class CameraRollCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setConfigure(assets: PHAsset) {
        let manager = PHImageManager()
        
        manager.requestImage(for: assets,
                             targetSize: frame.size,
                             contentMode: .aspectFill,
                             options: nil,
                             resultHandler: { [weak self] (image, info) in
                                guard let wself = self, let outImage = image else {
                                    return
                                }
                                wself.photoImageView.image = image
        })
    }
}
