//
//  SelectGenderModalViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/06.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit

class SelectGenderModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var genders = [String]()
    var selectedGender = String()
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var finishBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        finishBtn.setTitle(selectedGender + "に切り替え", for: UIControlState())
        
        var selectedNum = 0
        switch selectedGender {
        case "男性":
            selectedNum = 0
        case "女性":
            selectedNum = 1
        case "その他":
            selectedNum = 2
        default:
            selectedNum = 0
        }
        
        genders = [
            "男性",
            "女性",
            "その他"
        ]
        pickerView.selectRow(selectedNum, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishEditing(_ sender: Any) {
        let parent = presentingViewController as! EditTeamProfileViewController
        parent.updateGenderBtn(gender: selectedGender)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        selectedGender = genders[row]
        finishBtn.setTitle(selectedGender + "に切り替え", for: UIControlState())
        
    }
}
