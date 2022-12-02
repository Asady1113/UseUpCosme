//
//  SetButtonImage.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/01.
//

import UIKit

class DesignAddView {
    
    //画像を丸くする処理
    func designImage(image: UIImageView) {
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
    }
    
    //ボタンの画像セット
    func setImage(button: UIButton) {
        //画像をセット
        let picture = UIImage(named: "foundation.png")
        button.setImage(picture, for: .normal)
    }
    
    
    //日付のテキストフィールドを設定する
    func makeDatePicker(startDateTextField: UITextField,useupDateTextField: UITextField,view: UIView) {
        let startDatePicker: UIDatePicker = UIDatePicker()
        let useupDatePicker: UIDatePicker = UIDatePicker()
        
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.datePickerMode = UIDatePicker.Mode.date
        startDatePicker.timeZone = NSTimeZone.local
        startDatePicker.locale = Locale.current
        //バーの作成
        let startToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let startSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let startDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(startDoneDate))
        let startCancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(startCancelDate))
        startToolbar.setItems([startSpacelItem, startDoneItem], animated: true)
        
        startDateTextField.inputView = startDatePicker
        startDateTextField.inputAccessoryView = startToolbar
        
        
        useupDatePicker.preferredDatePickerStyle = .wheels
        useupDatePicker.datePickerMode = UIDatePicker.Mode.date
        useupDatePicker.timeZone = NSTimeZone.local
        useupDatePicker.locale = Locale.current
        //バーの作成
        let useupToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let useupSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let useupDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(useupDoneDate))
        let useupCancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(useupCancelDate))
        useupToolbar.setItems([useupSpacelItem, useupDoneItem], animated: true)
        
        useupDateTextField.inputView = useupDatePicker
        useupDateTextField.inputAccessoryView = useupToolbar
    }
    
    //完了ボタンを押した時の処理
    @objc func startDoneDate(){
    
    }
    
    @objc func startCancelDate(){
        
    }
    
    //完了ボタンを押した時の処理
    @objc func useupDoneDate(){
    
    }
    
    @objc func useupCancelDate(){
        
    }
}
