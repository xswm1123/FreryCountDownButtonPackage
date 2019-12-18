//
//  Date-extension.swift
//  MOSCTools
//
//  Created by Frery on 2019/12/16.
//  Copyright © 2019 Tima. All rights reserved.
//

import Foundation

extension Date{
    static func timeStamp() -> Int {
        let currentDate  = Date.init(timeIntervalSinceNow: 0)
        return Int(currentDate.timeIntervalSince1970)
    }
    static func getDateStringWith(Sec: UInt64, dateFormat:String) -> String {
        let date  = Date.init(timeIntervalSince1970: TimeInterval(Sec))
        let zone = NSTimeZone(name: "GMT")
        let dateFormater = DateFormatter.init()
        dateFormater.timeZone = zone as TimeZone?
        dateFormater.dateFormat = dateFormat
        return dateFormater.string(from: date)
    }
}
