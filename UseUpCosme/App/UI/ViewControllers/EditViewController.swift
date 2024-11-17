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
    private var editService: EditService!
    private var editView: EditViewProtocol!
    
    private var selectedCosme = CosmeModel()
    func setSelectedCosme(_ cosme: CosmeModel) {
        self.selectedCosme = cosme
    }
    private var resizedImage: UIImage?
    
    @IBOutlet private weak var cosmeImageView: UIImageView!
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
        editService = EditService()
        editView = EditView(view: self.view, cosmeImageView: cosmeImageView, cosmeNameTextField: cosmeNameTextField, startDateTextField: startDateTextField, limitDateTextField: limitDateTextField, categoryButtons: getOptionButtons())
    }
    
    private func getOptionButtons() -> [UIButton] {
        return [
            foundationButton, lipButton,
            cheekButton, mascaraButton, eyebrowButton,
            eyelinerButton, eyeshadowButton, skincareButton
        ]
    }
    
    private func configureUI() {
        editView.setInitialCategoryButtonImage(selectedCategory: selectedCosme.category)
        editView.setUpDatePickers()
        editView.displaySelectedCosmeData(selectedCosme: selectedCosme)
    }
    
    @IBAction private func selectImageByImageBtn(){
        showImagePicker()
    }
    
    // PickerViewに写真を表示する
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let resizedImage = selectedImage?.scale(byFactor: 0.3)
        editService.setSelectedImageData(selectedImage: resizedImage)
        cosmeImageView.image = resizedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    //カテゴリ選択関数
    @IBAction private func selectCategory(_sender: UIButton) {
        if editService.isSelectedSameCategory(_sender.tag) {
            editView.initCategoryButtonImage()
            return
        }
        editService.setSelectedCategoryNum(_sender.tag)
        editView.updateSelectedCategoryButtonImage(at: _sender.tag)
    }
    
    
    @IBAction func editCosmeByEditBtn() {
        KRProgressHUD.show()
        
        let (isInputDataError, inputDataErrorMessage) = editService.validateInputData(cosmeName: cosmeNameTextField.text, startDateText: startDateTextField.text, limitDateText: limitDateTextField.text)
        if isInputDataError {
            KRProgressHUD.showError(withMessage: inputDataErrorMessage)
            return
        }
        
        guard let selectedImageData = editService.getSelectdImagaData(),
              let cosmeName = cosmeNameTextField.text,
              let startDateText = startDateTextField.text,
              let limitDateText = limitDateTextField.text,
              let selectedCategory = editService.getSelectedCategory() else {
            return
        }
        
        let (startDate, limitDate) = editService.parseDate(startDateText: startDateText, limitDateText: limitDateText)
        let (isDateError, dateErrorMessage) = editService.validateDate(startDate: startDate, limitDate: limitDate)
        if isDateError {
            KRProgressHUD.showError(withMessage: dateErrorMessage)
            return
        }
        
        editService.editNotification(notificationId: selectedCosme.notificationId, cosmeName: cosmeName, limitDate: limitDate) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success():
                editSelectedCosme(objectId: selectedCosme.objectId, cosmeName: cosmeName, category: selectedCategory.rawValue, startDate: startDate, limitDate: limitDate, imageData: selectedImageData)
            case .failure(let error):
                KRProgressHUD.showError(withMessage: error.localizedDescription)
            }
        }
    }
    
    private func editSelectedCosme(objectId: String, cosmeName: String, category: String, startDate: Date, limitDate: Date, imageData: Data) {
        editService.editSelectedCosme(objectId: objectId, cosmeName: cosmeName, category: category, startDate: startDate, limitDate: limitDate, imageData: imageData) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success():
                KRProgressHUD.showMessage("保存が完了しました！")
                self.dismiss(animated: true)
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
    
    @IBAction private func useupCosme() {
        KRProgressHUD.show()
        editService.useUpCosme(selectedCosme: selectedCosme) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let count):
                editView.displayMessageOfUseUpCount(count: count, vc: self)
            case .failure(let error):
                switch error {
                case RealmError.realmFailedToStart:
                    KRProgressHUD.showError(withMessage: "処理に失敗しました")
                case RealmError.objectNotFound:
                    KRProgressHUD.showError(withMessage: "該当するコスメが見つかりません")
                default:
                    KRProgressHUD.showError(withMessage: error.localizedDescription)
                }
            }
            KRProgressHUD.dismiss()
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
