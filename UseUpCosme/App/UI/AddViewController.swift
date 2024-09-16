//
//  AddViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/08/30.
//

import UIKit
import KRProgressHUD
import NYXImagesKit

// TODO: ここからアーキテクチャ修正

class AddViewController: UIViewController {
    private var resizedImage: UIImage?
    private var selectedCategory: String?
    // ボタンとイメージの配列
    private var imagesArr = [UIImage]()
    private var buttonsArr = [UIButton]()
    
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
    }
    
    private func configureUI() {
        // ボタンに写真をセット
        imagesArr = [UIImage(named: "foundation.png")!, UIImage(named: "lip.png")!, UIImage(named: "cheek.png")!, UIImage(named: "mascara.png")!, UIImage(named: "eyebrow.png")!, UIImage(named: "eyeliner.png")!, UIImage(named: "eyeshadow.png")!, UIImage(named: "skincare.png")!]
        buttonsArr = [foundationButton, lipButton, cheekButton, mascaraButton, eyebrowButton, eyelinerButton,eyeshadowButton, skincareButton]
        DesignView.setImage(images: imagesArr, buttons: buttonsArr)
        // pickerの設定
        DesignView.makeDatePicker(startDateTextField: startDateTextField, useupDateTextField: useupDateTextField, view: view)
        // 鉛筆の画像を丸くする
        DesignView.designImage(image: pencilImageView)
    }
    
    // 入力されたデータを削除する
    private func deleteInputData() {
        DesignView.delete(cosmeImageView: cosmeImageView, cosmeNameTextField: cosmeNameTextField, startDateTextField: startDateTextField, useupDateTextField: useupDateTextField)
        selectedCategory = nil
    }

    // 画像選択の処理
    @IBAction private func selectImage(){
        self.showImagePicker()
    }
    
    // ImagePickerViewに写真を表示する
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        resizedImage = selectedImage?.scale(byFactor: 0.3)
        cosmeImageView.image = resizedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    // カテゴリ選択関数
    @IBAction private func selectCategory(_sender: UIButton) {
        let category = ["ファンデーション","口紅","チーク","マスカラ","アイブロウ","アイライナ-","アイシャドウ","スキンケア"]
        selectedCategory = category[_sender.tag]
        changeImage(_sender: _sender.tag)
    }
    
    // 選択されたボタンのイメージを変える
    private func changeImage(_sender: Int) {
        // 初期化
        DesignView.setImage(images: imagesArr, buttons: buttonsArr)
        
        var tappedImageArr = [UIImage(named: "foundation_tapped"), UIImage(named: "lip_tapped"), UIImage(named: "cheek_tapped"), UIImage(named: "mascara_tapped"), UIImage(named: "eyebrow_tapped"), UIImage(named: "eyeliner_tapped"), UIImage(named: "eyeshadow_tapped"), UIImage(named: "skincare_tapped")]
        
        buttonsArr[_sender].setImage(tappedImageArr[_sender], for: .normal)
    }
    
    // コスメを追加する
    @IBAction private func add() {
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
        guard cosme.isDateValidate != false else {
            return
        }
        
        RealmManager.uploadCosme(cosme: cosme.cosme) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success():
                self.deleteInputData()
                KRProgressHUD.showMessage("保存が完了しました！")
            case .failure(let error):
                switch error {
                case RealmError.realmFailedToStart:
                    KRProgressHUD.showError(withMessage: "保存処理に失敗しました")
                default:
                    KRProgressHUD.showError(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    // 保存するコスメをモデル化する
    private func createCosmeModel(cosmeName: String, selectedCategory: String, resizedImage: UIImage, startDateText: String, useupDateText: String) -> (cosme: CosmeModel, isDateValidate: Bool) {
        // 画像の調整とData化
        let imageData = arrangeImageToData(image: resizedImage)
        // 日付をDate型に変換する
        let startDate = Date.dateFromString(string: startDateText, format: "yyyy / MM / dd")
        let limitDate = Date.dateFromString(string: useupDateText, format: "yyyy / MM / dd")
        // 設定日付が正しいかを判定
        let isDateValidate = validateDate(startDate: startDate, limitDate: limitDate)
        if isDateValidate.bool == false {
            KRProgressHUD.showError(withMessage: isDateValidate.message)
            return (CosmeModel(), false)
        }
        // 通知を設定する
        let notificationId = NotificateFunction.makenotification(name: cosmeName, limitDate: limitDate)
        
        // モデル化
        let cosme = CosmeModel(cosmeName: cosmeName, category: selectedCategory, startDate: startDate, limitDate: limitDate, imageData: imageData, notificationId: notificationId, useup: false)
        return (cosme,true)
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
    private func validateDate(startDate: Date, limitDate: Date) -> (bool: Bool, message: String) {
        // 使用期限と本日の差分)
        let dateSubtractionFromToday = Int(limitDate.timeIntervalSince(Date()))
        // 使用期限と使用開始日の差分
        let dateSubtractionFromStart = Int(limitDate.timeIntervalSince(startDate))
        
        if dateSubtractionFromToday < 0 {
            return (false,"すでに期限が切れているようです")
        } else if dateSubtractionFromStart < 0 {
            return (false,"使用開始時に期限が切れているようです")
        }
        return (true, "")
    }
    
    @IBAction private func delete() {
        deleteInputData()
    }

}

extension AddViewController: UITextFieldDelegate {
    // キーボードを下げる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
