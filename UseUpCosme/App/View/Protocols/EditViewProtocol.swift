//
//  EditViewProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/30.
//

import UIKit

protocol EditViewProtocol {
    func setUpPencilImageView()
    func displaySelectedCosmeData(selectedCosme: CosmeModel)
    func initCategoryButtonImage()
    func updateSelectedCategoryButtonImage(at index: Int)
    func setInitialCategoryButtonImage(selectedCategory: String)
    func setUpDatePickers()
}
