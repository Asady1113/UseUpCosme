//
//  DetailService.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/22.
//

import Foundation

class DetailService: DetailServiceProtocol {
    private let realmManager: RealmManagerProtocol = RealmManager()

    func useUpCosme(selectedCosme: CosmeModel, completion: ((Result<Int, Error>) -> Void)?) {
        realmManager.useUpCosme(selectedCosme: selectedCosme) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success():
                realmManager.countUseUpCosmes { result in
                    switch result {
                    case .success(let count):
                        completion?(.success(count))
                    case .failure(_):
                        completion?(.failure(RealmError.realmFailedToStart))
                    }
                }
            case .failure(let error):
                switch error {
                case RealmError.realmFailedToStart:
                    completion?(.failure(RealmError.realmFailedToStart))
                case RealmError.objectNotFound:
                    completion?(.failure(RealmError.objectNotFound))
                default:
                    completion?(.failure(error))
                }
            }
        }
    }
    
}
