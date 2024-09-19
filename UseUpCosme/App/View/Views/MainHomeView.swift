//
//  MainHomeView.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/09/19.
//

import UIKit

class MainHomeView: MainHomeViewProtocol {
    private weak var tableView: UITableView?
    private var optionButtons: [UIButton]
    
    init(tableView: UITableView, optionButtons: [UIButton]) {
        self.tableView = tableView
        self.optionButtons = optionButtons
    }
    
    func setUpTableView() {
        tableView?.separatorStyle = .none
        let nib = UINib(nibName: "CosmeTableViewCell", bundle: Bundle.main)
        tableView?.register(nib, forCellReuseIdentifier: "Cell")
        
    }
    
    func reloadTableView() {
        tableView?.reloadData()
    }
    
    func initOptionButtonImage() {
        let optionButtonImageNames = [
            "clock.png", "foundation.png", "lip.png",
            "cheek.png", "mascara.png", "eyebrow.png",
            "eyeliner.png", "eyeshadow.png", "skincare.png"
        ]
        
        for (index, button) in optionButtons.enumerated() {
            button.setImage(UIImage(named: optionButtonImageNames[index]), for: .normal)
        }
    }
    
    func updateSelectedOptionButtonImage(at index: Int) {
        initOptionButtonImage()
        
        let tappedImageNames = [
            "clock_tapped", "foundation_tapped", "lip_tapped",
            "cheek_tapped", "mascara_tapped", "eyebrow_tapped",
            "eyeliner_tapped", "eyeshadow_tapped", "skincare_tapped"
        ]
        
        if let tappedImage = UIImage(named: tappedImageNames[index]) {
            optionButtons[index].setImage(tappedImage, for: .normal)
        }
    }
}
