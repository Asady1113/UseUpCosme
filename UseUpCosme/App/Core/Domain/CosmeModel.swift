//
//  CosmeModel.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/03/08.
//

import RealmSwift
import Foundation

class CosmeModel: Object {
    @objc dynamic var objectId = UUID().uuidString
    @objc dynamic var cosmeName = ""
    @objc dynamic var category = ""
    @objc dynamic var startDate = Date()
    @objc dynamic var limitDate = Date()
    @objc dynamic var imageData = Data()
    @objc dynamic var notificationId = ""
    @objc dynamic var useup = false
    @objc dynamic var useupDate: Date?
    
    override init() {
        super.init()
    }
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "objectId" // objectIdプロパティをプライマリキーとして指定
    }
    
    init(cosmeName: String, category: String, startDate: Date, limitDate: Date, imageData: Data, notificationId: String, useup: Bool) {
        self.cosmeName = cosmeName
        self.category = category
        self.startDate = startDate
        self.limitDate = limitDate
        self.imageData = imageData
        self.notificationId = notificationId
        self.useup = useup
        
        super.init()
    }
    
    func edit(cosmeName: String, category: String, startDate: Date, limitDate: Date, imageData: Data) {
        self.cosmeName = cosmeName
        self.category = category
        self.startDate = startDate
        self.limitDate = limitDate
        self.imageData = imageData
    }
}
