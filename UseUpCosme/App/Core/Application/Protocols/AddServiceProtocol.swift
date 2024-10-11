//
//  AddServiceProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/11.
//

import Foundation

protocol AddServiceProtocol {
    func isSelectedSameCategory(_ senderTag: Int) -> Bool
    func selectCategory(_ senderTag: Int)
}
