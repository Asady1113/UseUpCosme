//
//  MainHomeService.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/07/07.
//

import Foundation

class MainHomeService: MainHomeServiceProtocol {
    private let _realmManagerProtocol: RealmManagerProtocol = RealmManager()
    private var selectedOptionNum: Int?
    
    func getDisplayedCosmesByOption(_ senderTag: Int, prevDisplayedCosmes: [CosmeModel], allCosmes: [CosmeModel]) -> (nextDisplayedCosmes: [CosmeModel], isSelectSameOption: Bool) {
        
        var nextDisplayedCosmes = [CosmeModel]()
        // 選択中のボタンを押されたら初期化
        if selectedOptionNum == senderTag {
            // 初期化
            nextDisplayedCosmes = allCosmes
            selectedOptionNum = nil
            return (nextDisplayedCosmes: nextDisplayedCosmes, isSelectSameOption: true)
        }
        
        selectedOptionNum = senderTag
        if selectedOptionNum == 0 {
            nextDisplayedCosmes = sortCosmesByLimitDate(cosmes: prevDisplayedCosmes)
        } else {
            nextDisplayedCosmes = filterCosmesByCategory(senderTag, cosmes: allCosmes)
        }
        return (nextDisplayedCosmes: nextDisplayedCosmes, isSelectSameOption: false)
    }
    
    func sortCosmesByLimitDate(cosmes: [CosmeModel]) -> [CosmeModel] {
        // $0と$1にはそれぞれCosmeModelが入っている。それを比較する
        return cosmes.sorted(by: { $0.limitDate > $1.limitDate })
    }
    
    func filterCosmesByCategory(_ senderTag: Int, cosmes: [CosmeModel]) -> [CosmeModel] {
        let category: [CosmeCategory] = [
            .foundation,
            .lip, 
            .cheek,
            .mascara,
            .eyebrow, 
            .eyeliner,
            .eyeshadow,
            .skincare
        ]
        let selectedCategory = category[senderTag - 1]
        let filteredCosmeModels = cosmes.filter { $0.category == selectedCategory.rawValue }
        return filteredCosmeModels
    }
    
    func fetchCosmesNotUsedUp(completion: ((Result<[CosmeModel], Error>) -> Void)?) {
        _realmManagerProtocol.fetchCosmesByUseupData(useup: false) { [weak self] result in
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
