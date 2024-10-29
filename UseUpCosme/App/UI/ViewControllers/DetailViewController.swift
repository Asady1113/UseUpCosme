//
//  DetailViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/22.
//

import UIKit
import KRProgressHUD

class DetailViewController: UIViewController {
    private var detailService: DetailServiceProtocol!
    private var detailView: DetailViewProtocol!
    
    private var selectedCosme = CosmeModel()
    
    @IBOutlet private weak var cosmeImageView: UIImageView!
    @IBOutlet private weak var cosmeNameTextField: UITextField!
    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var limitDateTextField: UITextField!
    @IBOutlet private weak var useupButton: UIButton!
    
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
        detailService = DetailService()
        detailView = DetailView(cosmeImageView: cosmeImageView, cosmeNameTextField: cosmeNameTextField, startDateTextField: startDateTextField, limitDateTextField: limitDateTextField, useupButton: useupButton, categoryButtons: getOptionButtons())
    }
    
    private func getOptionButtons() -> [UIButton] {
        return [
            foundationButton, lipButton,
            cheekButton, mascaraButton, eyebrowButton,
            eyelinerButton, eyeshadowButton, skincareButton
        ]
    }
    
    private func configureUI() {
        detailView.setUpUseUpButton()
        detailView.initCategoryButtonImage(selectedCategory: selectedCosme.category)
        detailView.displaySelectedCosmeData(selectedCosme: selectedCosme)
    }
    
    func setSelectedCosme(_ selectedCosme: CosmeModel) {
        self.selectedCosme = selectedCosme
    }
    
    // 使い切りボタンを押されたら
    @IBAction private func tappedUseUpBotton() {
        useupCosme()
    }
    
    private func useupCosme() {
        KRProgressHUD.show()
        detailService.useUpCosme(selectedCosme: selectedCosme) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let count):
                KRProgressHUD.dismiss()
                detailView.displayMessageOfUseUpCount(count: count, vc: self)
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
        }
    }

    //編集画面へ
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? EditViewController {
            editVC.setSelectedCosme(selectedCosme)
        }
    }
    
    @IBAction private func back() {
        self.dismiss(animated: true)
    }
    
}
