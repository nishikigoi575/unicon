//
//  SetTeamImageViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/18.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit

class SetTeamImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var teamImage: UIImage?
    
    @IBOutlet weak var imageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        guard let teamImage = teamImage else { print("please set team image"); return }
        SetTeamIntroViewController.teamImage = teamImage
        performSegue(withIdentifier: "ToNext", sender: nil)
        
    }
    
    @IBAction func pickImage(_ sender: Any) {
        
        // The title and the message of the action sheet
        let actionSheet = UIAlertController(title: "チーム写真を選択", message: "選択方法を選択してください。", preferredStyle: .actionSheet)
        
        let openCamera = UIAlertAction(title: "カメラを起動", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            self.openCamera()
        })
        let openAlbum = UIAlertAction(title: "カメラロールから選択", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            self.openPhoto()
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            (action: UIAlertAction) -> Void in
        })
        // アクションシートに、定義した選択肢を追加する
        actionSheet.addAction(openCamera)
        actionSheet.addAction(openAlbum)
        actionSheet.addAction(cancel)
        
        // アクションシートを表示する
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage
            ] as? UIImage {
            
            teamImage = pickedImage
            imageBtn.setImage(pickedImage, for: UIControlState())
            
        }
        
        // カメラ画面(アルバム画面)を閉じる処理
        picker.dismiss(animated: true, completion: nil)
    }
    
    func openPhoto() {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    
    func openCamera() {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }

}
