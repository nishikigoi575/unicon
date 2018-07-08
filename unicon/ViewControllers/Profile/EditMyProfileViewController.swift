//
//  EditMyProfileViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/04.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import AlamofireImage

class EditMyProfileViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var changedImage: UIImage? = nil
    var changedIntro: String? = nil
    var changedBelonging: String? = nil

    @IBOutlet weak var saveBtnView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var belongingTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtnView.learningAndLeading()
        
        guard let user = User.current else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        belongingTextfield.delegate = self
        
        introTextView.delegate = self
        introTextView.textContainerInset = UIEdgeInsetsMake(20, 30, 20, 30)
        introTextView.sizeToFit()
        
        if let url = URL(string: user.userImage) {
            profileImageView.af_setImage(
                withURL: url,
                imageTransition: .crossDissolve(0.5))
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func finishEditing(_ sender: Any) {
        let userUID = User.current?.userUID

        UserService.update(userUID: userUID!, userImage: changedImage, intro: changedIntro, belonging: changedBelonging) { (user) in
            if let user = user {
                User.setCurrent(user, writeToUserDefaults: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                // FAILED TO UPDATE PROFILE
            }
        }
        
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func belongingChanged(_ sender: Any) {
        changedBelonging = belongingTextfield.text
    }
    
    @IBAction func pickImage(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ImagePicker", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "ImagePickerVC") as! CamerarollViewController
        newVC.from = self
        self.present(newVC, animated: true, completion: nil)
    }
    
    func updateImage(image: UIImage) {
        profileImageView.image = image
    }

    func textViewDidChange(_ textView: UITextView) {
        changedIntro = introTextView.text
    }
}
