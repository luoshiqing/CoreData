//
//  PersonModel.swift
//  MyCoreData
//
//  Created by DayHR on 2018/3/28.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit
import CoreData

class PersonModel: NSObject {

    let dbName = "Person"
    
    public var name: String?
    public var age: Int?
    public var id: Int?
    
    fileprivate lazy var contex: NSManagedObjectContext? = {
        guard let modelURL = Bundle.main.url(forResource: "ModelDB", withExtension: "momd") else{
            return nil
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else{
            return nil
        }
        let store = NSPersistentStoreCoordinator(managedObjectModel: model)
        guard let docStr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else{
            return nil
        }
        let sqlPath = (docStr as NSString).appendingPathComponent("coreData.sqlite")
        let sqlUrl = URL(fileURLWithPath: sqlPath)
        var endStore: NSPersistentStore?
        do {
            let result = try store.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqlUrl, options: nil)
            endStore = result
        } catch {
            return nil
        }
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = endStore?.persistentStoreCoordinator
        return context
    }()
    
    //增
    /*
     根据id作为唯一标识符
     如果数据库存在，则更新，否则添加
    */
    func add(success: ((Bool)->Swift.Void)?){
        
        guard let ctx = self.contex else {
            success?(false)
            return
        }
        
        guard let id = self.id else{
            success?(false)
            return
        }
        self.isHave(id: Int32(id), success: { (isHave) in
            if isHave{//已经存在
                print("已经存在")
                self.updata(success: { (isok) in
                    success?(isok)
                })
            }else{//不存在
                guard let person = NSEntityDescription.insertNewObject(forEntityName: self.dbName, into: ctx) as? Person else{
                    success?(false)
                    return
                }
                person.name = self.name
                
                if let age = self.age{
                    person.age = Int32(age)
                }
                if let id = self.id{
                    person.id = Int32(id)
                }
                do{
                    try ctx.save()
                    success?(true)
                }catch{
                    success?(false)
                }
            }
        })
    }
    //TODO:判定是否已经包含该id值
    fileprivate func isHave(id: Int32, success: ((Bool)->Swift.Void)?){
        
        guard let ctx = self.contex else {
            success?(false)
            return
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: dbName)
        let per = NSPredicate(format: "id = %d", id)
        request.predicate = per
        
        if let resArray = try? ctx.fetch(request){
            if let m = resArray as? [Person],m.count > 0{
                success?(true)
            }else{
                success?(false)
            }
        }else{
            success?(false)
        }
    }
    
    //删
    func delete(success: ((Bool)->Swift.Void)?){
        guard let ctx = self.contex else {
            success?(false)
            return
        }
        guard let id = self.id else{
            success?(false)
            return
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.dbName)
        let entity = NSEntityDescription.entity(forEntityName: self.dbName, in: ctx)
        let condition = "id=\(id)"
        let predicate = NSPredicate(format: condition, "")
        request.entity = entity
        request.predicate = predicate
        do {
            //先查询是否有满足的id
            let resultList = try ctx.fetch(request)
            //由于做了id唯一性，所以取第0个
            if let ps = resultList as? [Person],ps.count > 0{
                ctx.delete(ps[0])
                try ctx.save()
            }else{
                print("删除失败，没有符合的数据")
                success?(false)
            }
        } catch  {
            success?(false)
        }
    }
    
    //改
    func updata(success: ((Bool)->Swift.Void)?){
        guard let ctx = self.contex else {
            success?(false)
            return
        }
        guard let id = self.id else{
            success?(false)
            return
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.dbName)
        let entity = NSEntityDescription.entity(forEntityName: self.dbName, in: ctx)
        
        let condition = "id=\(id)"
        let predicate = NSPredicate(format: condition, "")
        request.entity = entity
        request.predicate = predicate
        do {
            //查找对应的id
            let list = try ctx.fetch(request)
            //需要保证id的唯一性，如果唯一，则最多只有一个值，否则取第0个元素
            if let ps = list as? [Person],ps.count > 0{
                let person = ps[0]
                person.name = self.name
                if let age = self.age{
                    person.age = Int32(age)
                }
                try ctx.save()
                success?(true)
            }else{
                print("更新失败，没有符合的id")
                success?(false)
            }
        } catch  {
            success?(false)
        }

    }
    //查
    /*
     如果不传递任何参数，则为查询所有数据
    */
    func search(id: Int?, name: String?, age: Int?,success: (([Person])->Swift.Void)?){
        guard let ctx = self.contex else {
            success?([])
            return
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.dbName)
        let entity = NSEntityDescription.entity(forEntityName: self.dbName, in: ctx)
        request.entity = entity
        
        var condition: String = ""
        
        if let tmpId = id{
            condition += "id=\(tmpId)"
        }
        if let tmpName = name{
            if condition.isEmpty{
                condition += "name=\(tmpName)"
            }else{
                condition += ",name=\(tmpName)"
            }
        }
        if let tmpAge = age{
            if condition.isEmpty{
                condition += "age=\(tmpAge)"
            }else{
                condition += ",age=\(tmpAge)"
            }
        }
        
        if !condition.isEmpty{
            let predicate = NSPredicate(format: condition, "")
            request.predicate = predicate
        }
        
        do {
            let list = try ctx.fetch(request)
            if let persons = list as? [Person],persons.count > 0{
                success?(persons)
            }else{
                print("未查询到任何数据")
                success?([])
            }
        } catch  {
            success?([])
        }
    }
}
