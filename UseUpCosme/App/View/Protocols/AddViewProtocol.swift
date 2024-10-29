//
//  AddViewProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/08.
//

import UIKit

protocol AddViewProtocol {
    func setUpPencilImageView()
    func initCategoryButtonImage()
    func updateSelectedCategoryButtonImage(at index: Int)
    func setUpDatePickers()
    func initUI()
}
