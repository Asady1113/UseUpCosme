//
//  DetailServiceProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/22.
//

import Foundation

protocol DetailServiceProtocol {
    func useUpCosme(selectedCosme: CosmeModel, completion: ((Result<Int, Error>) -> Void)?)
}
