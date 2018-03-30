//
//  DeleteViewController.swift
//  MyCoreData
//
//  Created by DayHR on 2018/3/28.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

class DeleteViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "删"
        self.idTF.delegate = self
        self.idTF.keyboardType = .numberPad
        self.nameTF.delegate = self
        self.ageTF.delegate = self
        self.ageTF.keyboardType = .numberPad
        self.deleteBtn.layer.cornerRadius = 38.0 / 2
        self.deleteBtn.layer.masksToBounds = true
    }
    @IBAction func deleteBtnAct(_ sender: Any) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.idTF.resignFirstResponder()
        self.nameTF.resignFirstResponder()
        self.ageTF.resignFirstResponder()
    }

}
