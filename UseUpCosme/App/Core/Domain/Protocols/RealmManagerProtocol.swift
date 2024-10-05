//
//  RealmManagerProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/09/16.
//

import Foundation

protocol RealmManagerProtocol {
    func fetchCosmes(isUsedUp: Bool, completion: ((Result<[CosmeModel], Error>) -> Void)?)
}
