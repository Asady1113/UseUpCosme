//
//  SetButtonImage.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/01.
//

import UIKit

class DesignAddView {
    static var startDateTextField: UITextField!
    static var useupDateTextField: UITextField!
    
    static let startDatePicker = UIDatePicker()
    static let useupDatePicker = UIDatePicker()
    
    // 画像を丸くする処理
    static func designImage(image: UIImageView) {
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
    }
    
    // ボタンの画像セット
    static func setImage(button: UIButton) {
        //画像をセット
        let picture = UIImage(named: "foundation.png")
        button.setImage(picture, for: .normal)
    }
    
    
    // 日付のテキストフィールドを設定する
    static func makeDatePicker(startDateTextField: UITextField,useupDateTextField: UITextField,view: UIView) {
        
        self.startDateTextField = startDateTextField
        self.useupDateTextField = useupDateTextField
        
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.datePickerMode = UIDatePicker.Mode.date
        startDatePicker.timeZone = NSTimeZone.local
        startDatePicker.locale = Locale.current
        //バーの作成
        let startToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let startSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let startDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(startDoneDate))
        let startCancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(startCancelDate))
        startToolbar.setItems([startCancelItem, startSpacelItem, startDoneItem], animated: true)
        
        self.startDateTextField.inputView = startDatePicker
        self.startDateTextField.inputAccessoryView = startToolbar
        
        
        useupDatePicker.preferredDatePickerStyle = .wheels
        useupDatePicker.datePickerMode = UIDatePicker.Mode.date
        useupDatePicker.timeZone = NSTimeZone.local
        useupDatePicker.locale = Locale.current
        //バーの作成
        let useupToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let useupSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let useupDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(useupDoneDate))
        let useupCancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(useupCancelDate))
        useupToolbar.setItems([useupCancelItem, useupSpacelItem, useupDoneItem], animated: true)
        
        self.useupDateTextField.inputView = useupDatePicker
        self.useupDateTextField.inputAccessoryView = useupToolbar
    }
    
    //完了ボタンを押した時の処理
    @objc static func startDoneDate(){
        self.startDateTextField.endEditing(true)
        self.startDateTextField.text = Date.stringFromDate(date: startDatePicker.date, format: "yyyy / MM / dd")
    }
    
    @objc static func startCancelDate(){
        self.startDateTextField.endEditing(true)
    }
    
    //完了ボタンを押した時の処理
    @objc static func useupDoneDate(){
        self.useupDateTextField.endEditing(true)
        self.useupDateTextField.text = Date.stringFromDate(date: useupDatePicker.date, format: "yyyy / MM / dd")
    }
    
    @objc static func useupCancelDate(){
        self.useupDateTextField.endEditing(true)
    }
    
    //初期化
    static func delete(cosmeImageView: UIImageView, cosmeNameTextField: UITextField, startDateTextField: UITextField, useupDateTextField: UITextField) {
        cosmeImageView.image = UIImage(named: "default-placeholder")
        cosmeNameTextField.text = nil
        startDateTextField.text = nil
        useupDateTextField.text = nil
    }
}
