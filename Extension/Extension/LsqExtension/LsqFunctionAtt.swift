//
//  LsqFunctionAtt.swift
//  Extension
//
//  Created by DayHR on 2018/10/31.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

let ScreenWidth     = UIScreen.main.bounds.width //屏幕宽度
let ScreenHeight    = UIScreen.main.bounds.height //屏幕高度
let statusHeight    = UIApplication.shared.statusBarFrame.height//状态栏高度
let scale375        = ScreenWidth / 375.0

//TODO:获取app版本号
public var appVersion: String {
    let infoDictionary = Bundle.main.infoDictionary
    if let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as? String{
        return currentAppVersion
    }else{
        return ""
    }
}
//TODO:获取版本build号
public var buildVersion: String{
    let infoDictionary = Bundle.main.infoDictionary
    guard let minorVersion = infoDictionary!["CFBundleVersion"] as? String else{
        return ""
    }
    return minorVersion
}

//TODO:拨打电话
public func callPhone(with phone: String, completionHandler: ((Bool)->Void)?){
    let p = "tel://" + phone
    if let url = URL(string: p){
        if #available(iOS 10.0, *){
            UIApplication.shared.open(url, options: [:]) { (isok) in
                completionHandler?(isok)
            }
        }else{
            UIApplication.shared.openURL(url)
        }
    }
}

//TODO:转json字符串
public func getJSONString(with data: Any)->String?{
    if !JSONSerialization.isValidJSONObject(data) {
        print("无法解析出JSONString")
        return nil
    }
    let data = try? JSONSerialization.data(withJSONObject: data, options: [])
    let jsonString = String(data: data!, encoding: .utf8)
    return jsonString
}

//TODO:字典相加
public func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

//TODO:延迟异步执行方法
public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
