//
//  RealmManager.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/03/08.
//

import Foundation
import RealmSwift

enum RealmError: Error {
    case realmFailedToStart
}

class RealmManager {
    // コスメの読み込み
    static func loadCosme(selectedCategory: String, useup: Bool, completion: ((Result<[CosmeModel], Error>) -> Void)?) {
        
        guard let realm = try? Realm() else {
            completion?(.failure(RealmError.realmFailedToStart))
            return
        }
        
        if selectedCategory != "all" {
            // もしカテゴリー縛りがあれば
            let result = realm.objects(CosmeModel.self).filter("category== %@ AND useup== %@", selectedCategory, useup)
            let cosmes = Array(result)
            completion?(.success(cosmes))
        } else {
            // なければ全て
            let result = realm.objects(CosmeModel.self).filter("useup== %@", useup)
            let cosmes = Array(result)
            completion?(.success(cosmes))
        }
    }
    
    // コスメの追加
    static func uploadCosme(cosme: CosmeModel, completion: ((Result<Void, Error>) -> Void)?) {
        guard let realm = try? Realm() else {
            completion?(.failure(RealmError.realmFailedToStart))
            return
        }
        
        try? realm.write {
            realm.add(cosme)
            completion?(.success(()))
        }
    }
    
    // コスメの使い切り
    static func useUpCosme(selectedCosme: CosmeModel, completion: ((Result<Void, Error>) -> Void)?) {
        guard let realm = try? Realm() else {
            completion?(.failure(RealmError.realmFailedToStart))
            return
        }
        
        let result = realm.objects(CosmeModel.self).filter("objectId== %@", selectedCosme.objectId)
        //resultを配列化する
        let object = Array(result)
        
        try? realm.write {
            // 使い切りに関するデータを登録する
            object.first?.useup = selectedCosme.useup
            object.first?.useupDate = Date()
            completion?(.success(()))
        }
    }
    
    // 使い切られたコスメの数を返す
    static func countUseUpCosme(completion: ((Result<Int, Error>) -> Void)?) {
        guard let realm = try? Realm() else {
            completion?(.failure(RealmError.realmFailedToStart))
            return
        }
        let result = realm.objects(CosmeModel.self).filter("useup== %@", true)
        completion?(.success(result.count))
    }
    
//    object.first?.edit(cosmeName: selectedCosme.cosmeName, category: selectedCosme.category, startDate: selectedCosme.startDate, limitDate: selectedCosme.limitDate, imageData: selectedCosme.imageData, useup: selectedCosme.useup)
}
