//
//  EditViewProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/30.
//

import UIKit

protocol EditViewProtocol {
    func displaySelectedCosmeData(selectedCosme: CosmeModel)
    func getCosmeName() -> String?
    func getStartDate() -> String?
    func getLimitDate() -> String?
    func initCategoryButtonImage()
    func updateSelectedCategoryButtonImage(at index: Int)
    func setInitialCategoryButtonImage(selectedCategory: String)
    func setUpDatePickers()
    func displayMessageOfUseUpCount(count: Int, vc: UIViewController)
}
