//
//  Cosme.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/17.
//

import Foundation
import NCMB

class Cosme: NSObject {
    var objectId: String?
    var user: NCMBUser
    var name: String
    var category: String
    var startDate: Date
    var limitDate: Date
    var imageUrl: String?
    var notificationId: String
    
    init(user: NCMBUser, name: String, category: String, startDate: Date, limitDate: Date, notificationId: String) {

        self.user = user
        self.name = name
        self.category = category
        self.startDate = startDate
        self.limitDate = limitDate
        self.notificationId = notificationId
        
    }
    

}
