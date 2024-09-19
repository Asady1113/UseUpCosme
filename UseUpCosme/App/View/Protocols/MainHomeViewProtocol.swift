//
//  MainHomeViewProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/09/19.
//

import UIKit

protocol MainHomeViewProtocol {
    func setUpTableView()
    func reloadTableView()
    func initOptionButtonImage()
    func updateSelectedOptionButtonImage(at index: Int)
}
