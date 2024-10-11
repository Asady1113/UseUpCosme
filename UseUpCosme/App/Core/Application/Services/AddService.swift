//
//  AddService.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/11.
//

import Foundation

class AddService: AddServiceProtocol {
    private var selectedCategoryNum: Int?
    
    func isSelectedSameCategory(_ senderTag: Int) -> Bool {
        if selectedCategoryNum == senderTag {
            selectedCategoryNum = nil
            return true
        }
        return false
    }
    
    func selectCategory(_ senderTag: Int) {
        selectedCategoryNum = senderTag
    }
}
