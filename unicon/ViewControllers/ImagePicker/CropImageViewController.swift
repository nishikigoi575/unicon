//
//  CropImageViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/30.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import CropViewController

class CropImageViewController: UIViewController, CropViewControllerDelegate {

    var selectedImage = UIImage()
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = selectedImage
        presentCropViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentCropViewController() {
        let image: UIImage = selectedImage
        
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.customAspectRatio = CGSize(width: 19.0, height: 24.0)
        cropViewController.resetAspectRatioEnabled = false
        cropViewController.rotateButtonsHidden = true
        
        
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        imageView.image = image
    }

}
