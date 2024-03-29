//
//  DateUtils.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/18.
//

import UIKit

class DateUtils {
    class func dateToString(dateString: Date, format: String) -> String? {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: dateString)
    }

    class func stringToDate(dateString: String, fromFormat: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = fromFormat
        return formatter.date(from: dateString)
    }
    
    //使用開始日からの経過日数
    class func dateFromStartDate(limitDate: Date) -> Int {
        let dateSubtraction = Calendar.current.dateComponents([.day], from: Date(), to: limitDate).day
        
        return dateSubtraction!
    }
}
