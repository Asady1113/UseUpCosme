//
//  AddView.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/08.
//

import UIKit

class AddView: AddViewProtocol {
    private var view: UIView
    private var cosmeImageView: UIImageView
    private var pencilImageView: UIImageView
    private var cosmeNameTextField: UITextField
    private var startDateTextField: UITextField
    private var useupDateTextField: UITextField
    private var optionButtons: [UIButton]
    
    init(view: UIView, cosmeImageView: UIImageView, pencilImageView: UIImageView, startDateTextField: UITextField, cosmeNameTextField: UITextField, useupDateTextField: UITextField, optionButtons: [UIButton]) {
        self.view = view
        self.cosmeImageView = cosmeImageView
        self.pencilImageView = pencilImageView
        self.cosmeNameTextField = cosmeNameTextField
        self.startDateTextField = startDateTextField
        self.useupDateTextField = useupDateTextField
        self.optionButtons = optionButtons
    }
    
    func setUpPencilImageView() {
        pencilImageView.layer.cornerRadius = 15
        pencilImageView.clipsToBounds = true
    }
    
    func initCategoryButtonImage() {
        let optionButtonImageNames = [
            "foundation.png", "lip.png",
            "cheek.png", "mascara.png", "eyebrow.png",
            "eyeliner.png", "eyeshadow.png", "skincare.png"
        ]
        
        for (index, button) in optionButtons.enumerated() {
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
            optionButtons[index].setImage(tappedImage, for: .normal)
        }
    }
    
    func setUpDatePickers() {
        let startDatePicker = UIDatePicker()
        let useupDatePicker = UIDatePicker()
        
        setUpDatePicker(textField: startDateTextField, datePicker: startDatePicker)
        setUpDatePicker(textField: useupDateTextField, datePicker: useupDatePicker)
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
    
    func initUI() {
        cosmeImageView.image = UIImage(named: "default-placeholder")
        cosmeNameTextField.text = nil
        startDateTextField.text = nil
        useupDateTextField.text = nil
    }
}

extension UIView {
    var currentFirstResponder: UIResponder? {
        if self.isFirstResponder {
            return self
        }
        for subview in subviews {
            if let responder = subview.currentFirstResponder {
                return responder
            }
        }
        return nil
    }
}
