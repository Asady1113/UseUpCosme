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

class RealmManager: RealmManagerProtocol {
    func fetchCosmes(isUsedUp: Bool, completion: ((Result<[CosmeModel], Error>) -> Void)?) {
        guard let realm = try? Realm() else {
            completion?(.failure(RealmError.realmFailedToStart))
            return
        }
        
        let result = realm.objects(CosmeModel.self).filter("useup== %@", isUsedUp)
        let cosmes = Array(result)
        completion?(.success(cosmes))
    }
    
    func createCosme(cosme: CosmeModel, completion: ((Result<Void, Error>) -> Void)?) {
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
    
    func useUpCosme(selectedCosme: CosmeModel, completion: ((Result<Void, Error>) -> Void)?) {
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
    
    func countUseUpCosmes(completion: ((Result<Int, Error>) -> Void)?) {
        guard let realm = try? Realm() else {
            completion?(.failure(RealmError.realmFailedToStart))
            return
        }
        let result = realm.objects(CosmeModel.self).filter("useup== %@", true)
        completion?(.success(result.count))
    }
    
    func editSelectedCosme(objectId: String, cosmeName: String, category: String, startDate: Date, limitDate: Date, imageData: Data, completion: ((Result<Void, Error>) -> Void)?) {
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
