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
    case objectNotFound
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
        
        do {
            try realm.write {
                realm.add(cosme)
                completion?(.success(()))
            }
        } catch {
            completion?(.failure(error))
        }
    }
    
    // コスメの使い切り
    static func useUpCosme(selectedCosme: CosmeModel, completion: ((Result<Void, Error>) -> Void)?) {
        guard let realm = try? Realm() else {
            completion?(.failure(RealmError.realmFailedToStart))
            return
        }
        
        if let object = realm.object(ofType: CosmeModel.self, forPrimaryKey: selectedCosme.objectId) {
                do {
                    try realm.write {
                        // 取得したオブジェクトの状態を更新
                        object.useup = true
                        object.useupDate = Date()
                        completion?(.success(()))
                    }
                } catch {
                    completion?(.failure(error))
                }
            } else {
                completion?(.failure(RealmError.objectNotFound))
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
    
    // コスメの編集
    static func editCosme(objectId: String, cosmeName: String, category: String, startDate: Date, limitDate: Date, imageData: Data, completion: ((Result<Void, Error>) -> Void)?) {
        guard let realm = try? Realm() else {
            completion?(.failure(RealmError.realmFailedToStart))
            return
        }
        
        if let object = realm.object(ofType: CosmeModel.self, forPrimaryKey: objectId) {
            do {
                try realm.write {
                    object.edit(cosmeName: cosmeName, category: category, startDate: startDate, limitDate: limitDate, imageData: imageData)
                    completion?(.success(()))
                }
            } catch {
                completion?(.failure(error))
            }
        } else {
            completion?(.failure(RealmError.objectNotFound))
        }
    }

}
