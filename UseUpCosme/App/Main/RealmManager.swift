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
    static func loadCosme(selectedCategory: String, completion: ((Result<[CosmeModel], Error>) -> Void)?) {
        
        guard let realm = try? Realm() else {
            completion?(.failure(RealmError.realmFailedToStart))
            return
        }
        
        if selectedCategory != "all" {
            // もしカテゴリー縛りがあれば
            let result = realm.objects(CosmeModel.self).filter("category== %@ AND useup== %@", selectedCategory, false)
            let cosmes = Array(result)
            completion?(.success(cosmes))
        } else {
            // なければ全て
            let result = realm.objects(CosmeModel.self).filter("useup== %@", false)
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
}
