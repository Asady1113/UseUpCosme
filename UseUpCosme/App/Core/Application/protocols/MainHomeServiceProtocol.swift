//
//  IMainHomeService.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/07/07.
//

import Foundation

protocol MainHomeServiceProtocol {
    func changeDisplayedCosmesByOptionBtn(_ senderTag: Int, prevDisplayedCosmes: [CosmeModel], allCosmes: [CosmeModel]) -> (nextDisplayedCosmes: [CosmeModel], isSelectSameOption: Bool)
    func sortCosmesByLimitDate(cosmes : [CosmeModel]) -> [CosmeModel]
    func filterCosmesByCategory(_ senderTag: Int, cosmes: [CosmeModel]) -> [CosmeModel]
    func loadCosmesByUseupData(useup: Bool, completion: ((Result<[CosmeModel], Error>) -> Void)?)
}
