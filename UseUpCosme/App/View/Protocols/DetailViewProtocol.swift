//
//  DetailViewProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/22.
//

import UIKit

protocol DetailViewProtocol {
    func setUpUseUpButton()
    func initCategoryButtonImage(selectedCategory: String)
    func displaySelectedCosmeData(selectedCosme: CosmeModel)
    func displayMessageOfUseUpCount(count: Int, vc: UIViewController)
}
