//
//  SelectGenderViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/18.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit

class SelectGenderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var genders = [String]()
    var selectedGender = String()
    
    @IBOutlet weak var yourGenderPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedGender = "男性"

        genders = [
            "男性",
            "女性",
            "その他"
        ]
        
        yourGenderPickerView.delegate = self
        yourGenderPickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextBtnTapped(_ sender: Any) {
        
        SetTeamIntroViewController.targetGender = selectedGender
        performSegue(withIdentifier: "ToNext", sender: nil)
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
        
    }

}
