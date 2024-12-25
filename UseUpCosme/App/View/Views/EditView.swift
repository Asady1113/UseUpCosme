//
//  EditView.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/30.
//

import UIKit

class EditView: EditViewProtocol {
    private var view: UIView
    private var cosmeImageView: UIImageView
    private var cosmeNameTextField: UITextField
    private var startDateTextField: UITextField
    private var limitDateTextField: UITextField
    private var categoryButtons: [UIButton]
    
    init(view: UIView, cosmeImageView: UIImageView, cosmeNameTextField: UITextField, startDateTextField: UITextField, limitDateTextField: UITextField, categoryButtons: [UIButton]) {
        self.view = view
        self.cosmeImageView = cosmeImageView
        self.cosmeNameTextField = cosmeNameTextField
        self.startDateTextField = startDateTextField
        self.limitDateTextField = limitDateTextField
        self.categoryButtons = categoryButtons
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
    
    func getCosmeName() -> String? {
        return cosmeNameTextField.text
    }
    
    func getStartDate() -> String? {
        return startDateTextField.text
    }
    
    func getLimitDate() -> String? {
        return limitDateTextField.text
    }
    
    func setInitialCategoryButtonImage(selectedCategory: String) {
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
    
    func initCategoryButtonImage() {
        let optionButtonImageNames = [
            "foundation.png", "lip.png",
            "cheek.png", "mascara.png", "eyebrow.png",
            "eyeliner.png", "eyeshadow.png", "skincare.png"
        ]
        
        for (index, button) in categoryButtons.enumerated() {
            button.setImage(UIImage(named: optionButtonImageNames[index]), for: .normal)
        }
    }
    
    func updateSelectedCategoryButtonImage(at index: Int) {
        initCategoryButtonImage()
        
        let tappedImageNames = [
            "foundation_tapped", "lip_tapped",
            "cheek_tapped", "mascara_tapped", "eyebrow_tapped",
            "eyeliner_tapped", "eyeshadow_tapped", "skincare_tapped"
        ]
        
        if let tappedImage = UIImage(named: tappedImageNames[index]) {
            categoryButtons[index].setImage(tappedImage, for: .normal)
        }
    }
    
    func setUpDatePickers() {
        let startDatePicker = UIDatePicker()
        let limitDatePicker = UIDatePicker()
        
        setUpDatePicker(textField: startDateTextField, datePicker: startDatePicker)
        setUpDatePicker(textField: limitDateTextField, datePicker: limitDatePicker)
    }
    
    func setUpDatePicker(textField: UITextField, datePicker: UIDatePicker) {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        //バーの作成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: true)
        
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
    }
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        guard let textField = view.currentFirstResponder as? UITextField,
              let datePicker = textField.inputView as? UIDatePicker else { return }
        
        textField.endEditing(true)
        textField.text = Date.stringFromDate(date: datePicker.date, format: "yyyy / MM / dd")
    }

    @objc func cancelTapped(sender: UIBarButtonItem) {
        guard let textField = view.currentFirstResponder as? UITextField else { return }
        textField.endEditing(true)
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
