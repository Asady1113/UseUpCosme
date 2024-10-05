//
//  IMainHomeService.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/07/07.
//

import Foundation

protocol CosmesListServiceProtocol {
    func getDisplayedCosmesByOption(_ senderTag: Int, prevDisplayedCosmes: [CosmeModel], allCosmes: [CosmeModel]) -> (nextDisplayedCosmes: [CosmeModel], isSelectSameOption: Bool)
    func sortCosmesByLimitDate(cosmes : [CosmeModel]) -> [CosmeModel]
    func filterCosmesByCategory(_ senderTag: Int, cosmes: [CosmeModel]) -> [CosmeModel]
    func fetchCosmes(isUsedUp: Bool, completion: ((Result<[CosmeModel], Error>) -> Void)?)
}
