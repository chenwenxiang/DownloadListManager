//
//  MyDate.swift
//  lingzhongshenghuo
//
//  Created by 陈文翔 on 2018/10/8.
//  Copyright © 2018 tsmc. All rights reserved.
//

import UIKit

class MyDate
{
    
    class func today(format : String = "yyyy-MM-dd HH:mm:ss") -> String
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format //自定义日期格式
        
        let time = dateformatter.string(from: Date())
        
        return time
    }
    
    class func timeFormat( timestamp : Int64, format : String = "yyyy-MM-dd HH:mm:ss") -> String
    {
        let timeInterval:TimeInterval = TimeInterval(timestamp)
        
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format //自定义日期格式
        
        let time = dateformatter.string(from: date as Date)
        
        return time
    }
    
    /// 日期字符串转化为Date类型
    class func stringToDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: string)
        return date
    }
    
    
    
    /// 根据当前日期，获取 days 天前的日期
    class func previouDate(days:Int, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String {
        
        let timestamp = Int64(Date().timeIntervalSince1970) - Int64( days * 86400 )
        
        return timeFormat(timestamp: timestamp, format: dateFormat)
    }
}


