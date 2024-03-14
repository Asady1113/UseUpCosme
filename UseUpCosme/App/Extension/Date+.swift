//
//  DateUtils.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/18.
//

import Foundation

extension Date {
    // Stringからdateへ
    static func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        guard let date = formatter.date(from: string) else {
            return Date()
        }
        return date
    }
    
    // dateからStringへ
    static func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // 使用期限までの残り日数
    static func dateToLimitDate(limitDate: Date) -> Int {
        guard let dateSubtraction = Calendar.current.dateComponents([.day], from: Date(), to: limitDate).day else {
            // バグだと気づけるように
            return 999
        }
        return dateSubtraction
    }
}
