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
    private var addService: AddServiceProtocol!
    private var addView: AddViewProtocol!
    
    private var selectedImageData: Data?
    
    @IBOutlet private weak var cosmeImageView: UIImageView!
    @IBOutlet private weak var pencilImageView: UIImageView!
    @IBOutlet private weak var cosmeNameTextField: UITextField!
    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var limitDateTextField: UITextField!
    
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
        di()
        configureUI()
    }
    
    private func di() {
        addService = AddService()
        addView = AddView(view: self.view, cosmeImageView: cosmeImageView, pencilImageView: pencilImageView, startDateTextField: startDateTextField, cosmeNameTextField: cosmeNameTextField, useupDateTextField: limitDateTextField, optionButtons: getOptionButtons())
    }
    
    private func getOptionButtons() -> [UIButton] {
        return [
            foundationButton, lipButton,
            cheekButton, mascaraButton, eyebrowButton,
            eyelinerButton, eyeshadowButton, skincareButton
        ]
    }
    
    private func configureUI() {
        addView.initCategoryButtonImage()
        addView.setUpDatePickers()
        addView.setUpPencilImageView()
    }

    // 画像選択の処理
    @IBAction private func selectImage(){
        self.showImagePicker()
    }
    
    // ImagePickerViewに写真を表示する
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let resizedImage = selectedImage?.scale(byFactor: 0.3)
        cosmeImageView.image = resizedImage
        
        if let resizedImage {
            selectedImageData = arrangeImageToData(image: resizedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // カテゴリ選択関数
    @IBAction private func selectCategory(_sender: UIButton) {
        if addService.isSelectedSameCategory(_sender.tag) {
            addView.initCategoryButtonImage()
            return
        }
        addService.setSelectedCategoryNum(_sender.tag)
        addView.updateSelectedCategoryButtonImage(at: _sender.tag)
    }
    
    // コスメを追加する
    @IBAction private func add() {
        KRProgressHUD.show()
        
        let (isInputDataError, inputDataErrorMessage)
        = addService.validateInputData(selectedImageDate: selectedImageData, cosmeName: cosmeNameTextField.text, startDateText: startDateTextField.text, limitDateText: limitDateTextField.text)
        if isInputDataError {
            KRProgressHUD.showError(withMessage: inputDataErrorMessage)
            return
        }
        
        guard let selectedImageData = selectedImageData,
              let cosmeName = cosmeNameTextField.text,
              let startDateText = startDateTextField.text,
              let limitDateText = limitDateTextField.text,
              let selectedCategory = addService.getSelectedCategory() else {
            return
        }
              
        let (startDate, limitDate) = addService.parseDate(startDateText: startDateText, limitDateText: limitDateText)
        let (isDateError, dateErrorMessage) = addService.validateDate(startDate: startDate, limitDate: limitDate)
        if isDateError {
            KRProgressHUD.showError(withMessage: dateErrorMessage)
            return
        }
        
        let cosme = addService.createCosmeModel(cosmeName: cosmeName, selectedCategoryString: selectedCategory.rawValue, selectedImageData: selectedImageData, startDate: startDate, limitDate: limitDate)
        
        addService.createCosme(cosme: cosme) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success():
                addView.initUI()
                addService.initSelectedCategoryNum()
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
    
    @IBAction private func delete() {
        addView.initUI()
        addService.initSelectedCategoryNum()
    }

}

extension AddViewController: UITextFieldDelegate {
    // キーボードを下げる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
