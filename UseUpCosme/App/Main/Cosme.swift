//
//  Cosme.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/17.
//

// 不要なクラス
import Foundation

class Cosme: NSObject {
    var objectId: String?
    var user: NCMBUser
    var name: String
    var category: String
    var startDate: Date
    var limitDate: Date
    var imageUrl: String?
    var notificationId: String
    var useup: Bool?
    var useupDate: Date?
    
    init(user: NCMBUser, name: String, category: String, startDate: Date, limitDate: Date, notificationId: String, useup: Bool) {

        self.user = user
        self.name = name
        self.category = category
        self.startDate = startDate
        self.limitDate = limitDate
        self.notificationId = notificationId
        self.useup = useup
        
    }
    

}
