//
//  MainHomeService.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/07/07.
//

import Foundation

class MainHomeService: MainHomeServiceProtocol {
    private let _realmManagerProtocol: RealmManagerProtocol = RealmManager()
    
    func sortCosmesByLimitDate(cosmes: [CosmeModel]) -> [CosmeModel] {
        // $0と$1にはそれぞれCosmeModelが入っている。それを比較する
        return cosmes.sorted(by: { $0.limitDate > $1.limitDate })
    }
    
    func filterCosmesByCategory(_ senderTag: Int, cosmes: [CosmeModel]) -> [CosmeModel] {
        // TODO: カテゴリ解除する機能つけたい
        let category = ["ファンデーション","口紅","チーク","マスカラ","アイブロウ","アイライナ-","アイシャドウ","スキンケア"]
        let selectedCategory = category[senderTag - 1]
        let filteredCosmeModels = cosmes.filter { $0.category == selectedCategory }
        return filteredCosmeModels
    }
    
    func loadCosmesByUseupData(useup: Bool, completion: ((Result<[CosmeModel], Error>) -> Void)?) {
        _realmManagerProtocol.loadCosmesByUseupData(useup: useup) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let cosmes):
                completion?(.success(cosmes))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
