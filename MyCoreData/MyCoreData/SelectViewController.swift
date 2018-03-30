//
//  SelectViewController.swift
//  MyCoreData
//
//  Created by DayHR on 2018/3/28.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

struct CellModel {
    var id: Int?
    var name: String?
    var age: Int?
}

class SelectViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    
    @IBOutlet weak var myTabView: UITableView!
    fileprivate var dataArray = [CellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "查"
        self.idTF.delegate = self
        self.idTF.keyboardType = .numberPad
        self.nameTF.delegate = self
        self.ageTF.delegate = self
        self.ageTF.keyboardType = .numberPad
        
        let rightItem = UIBarButtonItem(title: "查询", style: .plain, target: self, action: #selector(self.rightItemAct(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.myTabView.delegate = self
        self.myTabView.dataSource = self
        
        self.select(id: nil, name: nil, age: nil)
    }
    @objc fileprivate func rightItemAct(_ send: UIBarButtonItem){
        
    }
    
    func select(id: Int?, name: String?, age: Int?){
        
        let p = PersonModel()
        p.search(id: id, name: name, age: age) { [weak self](persons) in
            
            var datas = [CellModel]()
            for p in persons{
                var m = CellModel()
                m.age = Int(p.age)
                m.id = Int(p.id)
                m.name = p.name
                datas.append(m)
                print("id:\(m.id ?? 0),name:\(m.name ?? "/"),age:\(m.age ?? 0)")
            }
            print("\n")
            self?.dataArray = datas
            self?.myTabView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idf = "idf"
        var cell = tableView.dequeueReusableCell(withIdentifier: idf)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: idf)
        }
        cell?.selectionStyle = .none
        let model = self.dataArray[indexPath.row]
        let name = "name:" + (model.name ?? "")

        let age = "age:" + "\(model.age ?? 0)"
        let id = "id:" + "\(model.id ?? 0)"

        cell?.textLabel?.text = name
        cell?.detailTextLabel?.text = id + "   " + age
        return cell!
    }

}
