//
//  LsqExtension.swift
//  Extension
//
//  Created by DayHR on 2018/10/31.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

extension UIViewController{
    //导航栏和状态栏高度
    var navStatusHeigh: CGFloat{
        return statusHeight + self.navHeigh
    }
    var navHeigh: CGFloat{
        return self.navigationController?.navigationBar.frame.height ?? 0
    }
}

//MARK:UIColor扩展
extension UIColor {
    //16进制颜色
    @objc public class func hexColor(with string:String)->UIColor? {
        var cString = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.count < 6{
            return nil
        }
        if cString.hasPrefix("0X"){
            let index = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[index...])
        }
        if cString .hasPrefix("#"){
            let index = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[index...])
        }
        if cString.count != 6{
            return nil
        }
        
        let rrange = cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString[rrange])
        let grange = cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)
        let gString = String(cString[grange])
        let brange = cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6)
        let bString = String(cString[brange])
        var r:CUnsignedInt = 0 ,g:CUnsignedInt = 0 ,b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
    //RGB颜色
    @objc class func rgbColor(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    //导航栏颜色
    @objc public class var navColor: UIColor{
        return UIColor.hexColor(with: "#20a0ff")!
    }
    
    ////UIColor转成颜色图片
    public func conversionToImage() -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    //UIColor转成颜色图片
    public func conversionToImage(size: CGSize) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension String{
    //根据宽度跟字体，计算文字的高度
    func textAutoHeight(width: CGFloat, font: UIFont) -> CGFloat{
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let ssss = NSStringDrawingOptions.usesDeviceMetrics
        let rect = string.boundingRect(with: CGSize(width: width, height: 0), options: [origin,lead,ssss], attributes: [NSAttributedString.Key.font:font], context: nil)
        return rect.height
    }
    //根据高度跟字体，计算文字的宽度
    func textAutoWidth(height: CGFloat, font: UIFont)->CGFloat{
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let rect = string.boundingRect(with: CGSize(width: 0, height: height), options: [origin,lead], attributes: [NSAttributedString.Key.font:font], context: nil)
        return rect.width
    }
    //判断正则
    func isRegex(with regex: Regex)->Bool{
        return MyRegex(regex.rawValue).match(input: self)
    }
    //字符串转date
    func toDate(type: TimeFormat)->Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        let date = formatter.date(from: self)
        return date
    }
    //判断是否只包含空格
    var isSpace: Bool{
        let set = CharacterSet.whitespacesAndNewlines
        let trimedString = self.trimmingCharacters(in: set)
        if trimedString.count == 0{
            return true
        }else{
            return false
        }
    }
    //json字符串转换成字典
    var dictionary: [String:Any]?{
        guard let data = self.data(using: .utf8) else{ return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] else{
            return nil
        }
        return dict
    }
}


//正则
struct MyRegex {
    
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String)->Bool{
        
        if let matches = self.regex?.matches(in: input, options: [], range: NSMakeRange(0, input.count)){
            return matches.count > 0
        }else{
            return false
        }
    }
}

enum Regex: String {
    case userName   = "^[a-z0-9_-]{3,16}$"
    case phone      = "^1[0-9]{10}$"
    case idCard     = "^(\\d{14}|\\d{17})(\\d|[xX])$"
    case password   = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"
}


//时间戳转换
enum TimeFormat: String {
    //y表示年份，m表示月份，d表示日，h表示小时，m表示分钟，s表示秒
    case yyyy_MM_dd_HH_mm_ss    = "yyyy-MM-dd HH:mm:ss"
    case yyyy_MM_dd_HH_mm       = "yyyy-MM-dd HH:mm"
    case yyyy_MM_dd_HH          = "yyyy-MM-dd HH"
    case yyyy_MM_dd             = "yyyy-MM-dd"
    case yyyyMMdd               = "yyyy.MM.dd"
    case yyyyMM                 = "yyyy.MM"
    case yyyy_MM                = "yyyy-MM"
    case HH_mm                  = "HH:mm"
    case yyyy                   = "yyyy"
    case MM                     = "MM"
}

extension Date{
    
    //转字符串格式
    func toString(type: TimeFormat)->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = type.rawValue
        let dateStr = dateFormat.string(from: self)
        return dateStr
    }
    
    //获取当前月份第一天的星期的下标位置
    public func weekDayIndex()->Int{
        var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let timeZone = TimeZone.current
        calendar.timeZone = timeZone
        let theComponents = calendar.component(.weekday, from: self)
        return theComponents - 1
    }
    //TODO:获取时间的月份的开始日期
    public func monthStartDay()->Date?{
        guard let date = self.toString(type: .yyyy_MM).toDate(type: .yyyy_MM) else{
            return nil
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month], from: date)
        let startDay = calendar.date(from: components)
        return startDay
    }
    //TODO:获取时间的月份的结束日期
    public func monthEndDay(endTime: Bool)->Date?{
        guard let date = self.toString(type: .yyyy_MM).toDate(type: .yyyy_MM) else{
            return nil
        }
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = 1
        if endTime{
            components.second = -1
        }else{
            components.day = -1
        }
        let endDay = calendar.date(byAdding: components, to: date)
        return endDay
    }
    //TODO:获取时间的月份一共的天数
    public func monthDaysCount()->Int?{
        let calendar = Calendar.current
        let nowComps = calendar.dateComponents([.year,.month,.day], from: self)
        guard let year = nowComps.year, let month = nowComps.month else{
            return nil
        }
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year
        guard let startDate = calendar.date(from: startComps), let endDate = calendar.date(from: endComps) else{
            return nil
        }
        let diff = calendar.dateComponents([.day], from: startDate, to: endDate)
        let dayCount = diff.day
        return dayCount
    }
    //TODO:获取时间对应的年份的开始日期
    public func yearStartEndDay()->(start: Date, end: Date){
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        let startOfYear = calendar.date(from: components) ?? self
        
        var endComp = DateComponents()
        endComp.year = 1
        endComp.second = -1
        let date = self.toString(type: .yyyy).toDate(type: .yyyy) ?? self
        let endOfYear = calendar.date(byAdding: endComp, to: date) ?? self
        
        return (startOfYear,endOfYear)
    }
}

extension UIFont {
    class func auto(font: CGFloat)->UIFont{
        var fontSize: CGFloat = font
        fontSize *= scale375
        return UIFont.systemFont(ofSize: fontSize)
    }
}

extension UIImage{
    //图片尺寸的压缩
    func resizeImage() -> UIImage{
        let contrastWidth: CGFloat = 1280
        let width = self.size.width
        let height = self.size.height
        let scale = width / height
        var sizeChange = CGSize()
        if width <= contrastWidth && height < contrastWidth{
            //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            return self
        }else if width > contrastWidth || height > contrastWidth{
            //b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
            if scale <= 2 && scale >= 1{
                let changeWidth: CGFloat = contrastWidth
                let changeHeight: CGFloat = changeWidth / scale
                sizeChange = CGSize(width: changeWidth, height: changeHeight)
            }else if scale >= 0.5 && scale <= 1{
                let changeHeight = contrastWidth
                let changeWidth = changeHeight * scale
                sizeChange = CGSize(width: changeWidth, height: changeHeight)
            }else if width > contrastWidth && height > contrastWidth {
                //c,宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
                if scale > 2{//高的值比较小
                    let changeHeight = contrastWidth
                    let changeWidth = changeHeight * scale
                    sizeChange = CGSize(width: changeWidth, height: changeHeight)
                }else{//宽的值比较小
                    let changeWidth = contrastWidth
                    let changeHeight = changeWidth / scale
                    sizeChange = CGSize(width: changeWidth, height: changeHeight)
                }
            }else{ //d, 宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
                return self
            }
        }
        UIGraphicsBeginImageContext(sizeChange)
        self.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImg!
    }
    //图片大小压缩
    func compressData()->Data{
        let data = self.jpegData(compressionQuality: 1)!
        let kb = data.count / 1024
        var size: CGFloat = 0.1
        if kb > 1500{
            size = 0.3
        }else if kb > 600 {
            size = 0.4
        }else if kb > 400{
            size = 0.5
        }else if kb > 300{
            size = 0.6
        }else if kb > 200{
            size = 0.8
        }else{
            size = 1
        }
        let endData = self.jpegData(compressionQuality: size)!
        return endData
    }
    
    //图片圆角
    public func roundImage(radius: CGFloat)->UIImage?{
        let original = self
        let frame = CGRect(x: 0, y: 0, width: original.size.width, height: original.size.height)
        UIGraphicsBeginImageContextWithOptions(original.size, false, 1.0)
        UIBezierPath(roundedRect: frame, cornerRadius: radius).addClip()
        original.draw(in: frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension TimeInterval {
    //时间戳转时间(需要秒级)
    func toDate(type: TimeFormat)->String{
        let date = Date(timeIntervalSince1970: self)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = type.rawValue
        let time = dateformatter.string(from: date)
        return time
    }
}

extension UIView{
    //获取视图的控制器
    public var viewController: UIViewController?{
        var next: UIResponder?
        next = self.next
        repeat{
            if (next as? UIViewController) != nil{
                return (next as? UIViewController)
            }else{
                next = next?.next
            }
        }while next != nil
        return (next as? UIViewController)
    }
    
    //位置
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: newValue)
        }
    }
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.height)
        }
    }
    
    public var top: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.width, height: self.frame.height)
        }
        
    }
    public var bottom: CGFloat{
        get{
            return self.frame.origin.y + self.frame.height
        }
        set{
            let y = newValue + self.frame.height
            self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.frame.width, height: self.frame.height)
        }
        
    }
    public var left: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
        
    }
    public var right: CGFloat{
        get{
            return self.frame.origin.x + self.frame.width
        }
        set{
            let x = newValue - self.frame.width
            self.frame = CGRect(x: x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
    }
    
    
    
    //设置圆角
    public func setBorder(width: CGFloat, color: UIColor, top: Bool, right: Bool, bottom: Bool, left: Bool){
        if top{
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
        if right{
            let layer = CALayer()
            layer.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
        if bottom{
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.height - width, height: width)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
        if left{
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
    }
    
    public func setRoundBorder(rectCorners: UIRectCorner,fillColor: UIColor, strokeColor: UIColor){
        
        let mask = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorners, cornerRadii: CGSize(width: 4, height: 4))
        mask.lineWidth = 0.5
        let shape = CAShapeLayer()
        shape.fillColor = fillColor.cgColor
        shape.strokeColor = strokeColor.cgColor
        shape.path = mask.cgPath
        shape.frame = self.bounds
        self.layer.addSublayer(shape)
    }
    
    
}
