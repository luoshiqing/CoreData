//
//  UpdataViewController.swift
//  MyCoreData
//
//  Created by DayHR on 2018/3/28.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

class UpdataViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var updataBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "改"
        self.idTF.delegate = self
        self.idTF.keyboardType = .numberPad
        self.nameTF.delegate = self
        self.ageTF.delegate = self
        self.ageTF.keyboardType = .numberPad
        self.updataBtn.layer.cornerRadius = 38.0 / 2
        self.updataBtn.layer.masksToBounds = true
    }

    @IBAction func updataBtnAct(_ sender: Any) {
        self.view.endEditing(true)
        let idText = self.idTF.text ?? ""
        if idText.isEmpty{
            self.statusLabel.text = "状态:必须填写id"
            return
        }
        let ageText = self.ageTF.text!
        let nameText = self.nameTF.text!
        let personM = PersonModel()
        
        personM.id = Int(idText)
        personM.age = Int(ageText)
        personM.name = nameText

        personM.updata { (isok) in
            if isok{
                self.statusLabel.text = "状态:更新数据库成功"
            }else{
                self.statusLabel.text = "状态:更新数据库失败"
            }
        }
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
