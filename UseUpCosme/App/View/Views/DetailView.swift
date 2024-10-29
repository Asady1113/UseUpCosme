//
//  DetailView.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/22.
//

import UIKit

class DetailView: DetailViewProtocol {
    private var cosmeImageView: UIImageView!
    private var cosmeNameTextField: UITextField!
    private var startDateTextField: UITextField!
    private var limitDateTextField: UITextField!
    private var useupButton: UIButton
    private var categoryButtons: [UIButton]
    
    init(cosmeImageView: UIImageView, cosmeNameTextField: UITextField, startDateTextField: UITextField, limitDateTextField: UITextField, useupButton: UIButton, categoryButtons: [UIButton]) {
        self.cosmeImageView = cosmeImageView
        self.cosmeNameTextField = cosmeNameTextField
        self.startDateTextField = startDateTextField
        self.limitDateTextField = limitDateTextField
        self.useupButton = useupButton
        self.categoryButtons = categoryButtons
    }
    
    func setUpUseUpButton() {
        useupButton.layer.cornerRadius = 7
        useupButton.clipsToBounds = true
    }
    
    func initCategoryButtonImage(selectedCategory: String) {
        let categories = [CosmeCategory.foundation, CosmeCategory.lip, CosmeCategory.cheek, CosmeCategory.mascara, CosmeCategory.eyebrow, CosmeCategory.eyeliner, CosmeCategory.eyeshadow, CosmeCategory.skincare]
        let optionButtonImageNames = [
            "foundation.png", "lip.png",
            "cheek.png", "mascara.png", "eyebrow.png",
            "eyeliner.png", "eyeshadow.png", "skincare.png"
        ]
        let tappedImageNames = [
            "foundation_tapped", "lip_tapped",
            "cheek_tapped", "mascara_tapped", "eyebrow_tapped",
            "eyeliner_tapped", "eyeshadow_tapped", "skincare_tapped"
        ]
        
        for (index, button) in categoryButtons.enumerated() {
            if categories[index].rawValue == selectedCategory {
                button.setImage(UIImage(named: tappedImageNames[index]), for: .normal)
            } else {
                button.setImage(UIImage(named: optionButtonImageNames[index]), for: .normal)
            }
        }
    }
    
    func displaySelectedCosmeData(selectedCosme: CosmeModel) {
        // 画像取得
        let data = selectedCosme.imageData
        let image = UIImage(data: data)
        cosmeImageView.image = image
        
        cosmeNameTextField.text = selectedCosme.cosmeName
        startDateTextField.text = Date.stringFromDate(date: selectedCosme.startDate, format: "yyyy / MM / dd")
        limitDateTextField.text = Date.stringFromDate(date: selectedCosme.limitDate, format: "yyyy / MM / dd")
    }
    
    func displayMessageOfUseUpCount(count: Int, vc: UIViewController) {
        let alert = UIAlertController(title: "使い切りおめでとう！", message: "これであなたが使い切ったコスメは\(String(describing: count))個目です！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "閉じる", style: .default) { action in
            alert.dismiss(animated: true)
            vc.dismiss(animated: true)
        }
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}

