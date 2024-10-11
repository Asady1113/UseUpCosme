//
//  MainHomeService.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/07/07.
//

import Foundation

class CosmesListService: CosmesListServiceProtocol {
    private let _realmManagerProtocol: RealmManagerProtocol = RealmManager()
    private var selectedOptionNum: Int?
    
    func isSelectedSameOption(_ senderTag: Int) -> Bool {
        if selectedOptionNum == senderTag {
            selectedOptionNum = nil
            return true
        }
        return false
    }
    
    func getDisplayedCosmesByOption(_ senderTag: Int, prevDisplayedCosmes: [CosmeModel], allCosmes: [CosmeModel]) -> [CosmeModel] {
        
        var nextDisplayedCosmes = [CosmeModel]()
        selectedOptionNum = senderTag
        if selectedOptionNum == 0 {
            nextDisplayedCosmes = sortCosmesByLimitDate(cosmes: prevDisplayedCosmes)
        } else {
            nextDisplayedCosmes = filterCosmesByCategory(senderTag, cosmes: allCosmes)
        }
        return nextDisplayedCosmes
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
    
    func fetchCosmes(isUsedUp: Bool, completion: ((Result<[CosmeModel], Error>) -> Void)?) {
        _realmManagerProtocol.fetchCosmes(isUsedUp: isUsedUp) { [weak self] result in
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
