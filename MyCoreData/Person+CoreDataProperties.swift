//
//  Person+CoreDataProperties.swift
//  MyCoreData
//
//  Created by DayHR on 2018/3/28.
//  Copyright © 2018年 zhcx. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int32
    @NSManaged public var id: Int32
}
