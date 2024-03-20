//
//  EditViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/26.
//

import UIKit
import KRProgressHUD
import NYXImagesKit

class EditViewController: UIViewController {
    private var selectedCosme: CosmeModel?
    func setSelectedCosme(_ cosme: CosmeModel) {
        self.selectedCosme = cosme
    }
    private var selectedCategory: String?
    private var resizedImage: UIImage?
    
    @IBOutlet private weak var cosmeImageView: UIImageView!
    @IBOutlet private weak var pencilImageView: UIImageView!
    
    @IBOutlet private weak var cosmeNameTextField: UITextField!
    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var useupDateTextField: UITextField!
    
    @IBOutlet private weak var foundationButton: UIButton!
    @IBOutlet private weak var lipButton: UIButton!
    @IBOutlet private weak var cheekButton: UIButton!
    @IBOutlet private weak var mascaraButton: UIButton!
    @IBOutlet private weak var eyebrowButton: UIButton!
    @IBOutlet private weak var eyelinerButton: UIButton!
    @IBOutlet private weak var eyeshadowButton: UIButton!
    @IBOutlet private weak var skincareButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        showCosme()
    }
    
    private func configureUI() {
        // ボタンに写真をセット
        DesignView.setImage(images: [UIImage(named: "foundation.png"), UIImage(named: "lip.png"), UIImage(named: "cheek.png"), UIImage(named: "mascara.png"), UIImage(named: "eyebrow.png"), UIImage(named: "eyeliner.png"), UIImage(named: "eyeshadow.png"), UIImage(named: "skincare.png")], buttons: [foundationButton, lipButton, cheekButton, mascaraButton, eyebrowButton, eyelinerButton,eyeshadowButton, skincareButton])
        // pickerの設定
        DesignView.makeDatePicker(startDateTextField: startDateTextField, useupDateTextField: useupDateTextField, view: view)
        // 鉛筆の画像を丸くする
        DesignView.designImage(image: pencilImageView)
    }
    
    private func showCosme() {
        guard let selectedCosme else {
            return
        }
        // カテゴリー
        selectedCategory = selectedCosme.category
        // 画像取得
        let data = selectedCosme.imageData
        let image = UIImage(data: data)
        cosmeImageView.image = image
        resizedImage = image
        
        cosmeNameTextField.text = selectedCosme.cosmeName
        startDateTextField.text = Date.stringFromDate(date: selectedCosme.startDate, format: "yyyy / MM / dd")
        useupDateTextField.text = Date.stringFromDate(date: selectedCosme.limitDate, format: "yyyy / MM / dd")
    }
    
    @IBAction private func selectImage(){
        showImagePicker()
    }
    
    // PickerViewに写真を表示する
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        resizedImage = selectedImage?.scale(byFactor: 0.3)
       
        cosmeImageView.image = resizedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    //カテゴリ選択関数
    @IBAction private func selectCategory(_sender: UIButton) {
        let category = ["ファンデーション","口紅","チーク","マスカラ","アイブロウ","アイライナ-","アイシャドウ","スキンケア"]
        selectedCategory = category[_sender.tag]
    }
    
    
    @IBAction func edit() {
        KRProgressHUD.show()
        // 画像が選択されていなければリターン
        guard let resizedImage = resizedImage else {
            KRProgressHUD.showError(withMessage: "画像を登録してください")
            return
        }
        // 各項目が入力されているか
        guard let cosmeName = cosmeNameTextField.text else {
            KRProgressHUD.showError(withMessage: "名前を登録してください")
            return
        }
        guard let startDateText = startDateTextField.text else {
            KRProgressHUD.showError(withMessage: "使用開始日を登録してください")
            return
        }
        guard let useupDateText = useupDateTextField.text else {
            KRProgressHUD.showError(withMessage: "使用期限を登録してください")
            return
        }
        guard let selectedCategory = selectedCategory else {
            KRProgressHUD.showError(withMessage: "カテゴリを登録してください")
            return
        }
        // モデル化してDBに保存する
        let cosme = createCosmeModel(cosmeName: cosmeName, selectedCategory: selectedCategory, resizedImage: resizedImage, startDateText: startDateText, useupDateText: useupDateText)
        RealmManager.editCosme(selectedCosme: cosme) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success():
                KRProgressHUD.dismiss()
                // 元の画面へ
                self.dismiss(animated: true)
            case .failure(let error):
                KRProgressHUD.showError(withMessage: "保存に失敗しました")
            }
        }
    }
    
    // 保存するコスメをモデル化する
    private func createCosmeModel(cosmeName: String, selectedCategory: String, resizedImage: UIImage, startDateText: String, useupDateText: String) -> CosmeModel {
        guard let selectedCosme else {
            return CosmeModel()
        }
        // 画像の調整とData化
        let imageData = arrangeImageToData(image: resizedImage)
        // 日付をDate型に変換する
        let startDate = Date.dateFromString(string: startDateText, format: "yyyy / MM / dd")
        let limitDate = Date.dateFromString(string: useupDateText, format: "yyyy / MM / dd")
        // 設定日付が正しいかを判定
        validateDate(startDate: startDate, limitDate: limitDate)
        // 通知を編集する
        NotificateFunction.editNotification(objectId: selectedCosme.objectId, name: cosmeName, limitDate: limitDate)
        let cosme = CosmeModel(objectId: selectedCosme.objectId, cosmeName: cosmeName, category: selectedCategory, startDate: startDate, limitDate: limitDate, imageData: imageData, useup: selectedCosme.useup)
        return cosme
    }
    
    // 画像の調整とデータ化
    private func arrangeImageToData(image: UIImage) -> Data {
        // 画像を調整
        UIGraphicsBeginImageContext(image.size)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return Data()
        }
        UIGraphicsEndImageContext()
        // pngに変換
        guard let imageData = image.pngData() else {
            return Data()
        }
        return imageData
    }
    
    // 使用期限の設定が正しいかどうか
    private func validateDate(startDate: Date, limitDate: Date) {
        // 使用期限と本日の差分
        let dateSubtractionFromToday = Int(limitDate.timeIntervalSince(Date()))
        // 使用期限と使用開始日の差分
        let dateSubtractionFromStart = Int(limitDate.timeIntervalSince(startDate))
        
        if dateSubtractionFromToday < 0 {
            KRProgressHUD.showError(withMessage: "すでに期限が切れているようです")
            return
        } else if dateSubtractionFromStart < 0 {
            KRProgressHUD.showError(withMessage: "使用開始時に期限が切れているようです")
            return
        }
    }
    
    @IBAction private func back() {
        self.dismiss(animated: true)
    }
}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
