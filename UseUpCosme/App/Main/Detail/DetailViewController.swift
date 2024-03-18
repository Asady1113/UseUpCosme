//
//  DetailViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/22.
//

import UIKit
import KRProgressHUD

class DetailViewController: UIViewController {
    
    private var cosme: CosmeModel?
    func setCosme(_ cosme: CosmeModel) {
        self.cosme = cosme
    }
    private var selectedCategory: String {
        guard let cosme else {
            return ""
        }
        return cosme.category
    }
    private var useUpCount = 0
    
    @IBOutlet private weak var cosmeImageView: UIImageView!
    @IBOutlet private weak var cosmeNameTextField: UITextField!
    @IBOutlet private weak var startDateTextField: UITextField!
    @IBOutlet private weak var useupDateTextField: UITextField!
    @IBOutlet private weak var useupButton: UIButton!
    
    @IBOutlet private weak var category1: UIButton!
    @IBOutlet private weak var category2: UIButton!
    @IBOutlet private weak var category3: UIButton!
    @IBOutlet private weak var category4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        showCosme()
    }
    
    private func configureUI() {
        useupButton.layer.cornerRadius = 7
        useupButton.clipsToBounds = true
    }
    
    private func showCosme() {
        guard let cosme else {
            return
        }
        // 画像取得
        let data = cosme.imageData
        let image = UIImage(data: data)
        cosmeImageView.image = image
        
        cosmeNameTextField.text = cosme.cosmeName
        startDateTextField.text = Date.stringFromDate(date: cosme.startDate, format: "yyyy / MM / dd")
        useupDateTextField.text = Date.stringFromDate(date: cosme.limitDate, format: "yyyy / MM / dd")
    }
    
    // 使い切りボタンを押されたら
    @IBAction private func useUpBottonTapped() {
        guard let cosme else {
            return
        }
        cosme.useup = true
        useupCosme(cosme: cosme)
    }
    
    // 使い切りの処理
    private func useupCosme(cosme: CosmeModel) {
        KRProgressHUD.show()
        RealmManager.useUpCosme(selectedCosme: cosme) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success():
                self.countUseUpCosme()
                KRProgressHUD.dismiss()
            case .failure(let error):
                KRProgressHUD.showError(withMessage: "保存に失敗しました")
            }
        }
    }
    
    // 使い切ったコスメの数を数える
    private func countUseUpCosme() {
        RealmManager.countUseUpCosme { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let count):
                self.showMessageOfUseUpCount(count: count)
            case .failure(let error):
                KRProgressHUD.showError(withMessage: "データの読み込みに失敗しました")
            }
        }
    }
    
    private func showMessageOfUseUpCount(count: Int) {
        let alert = UIAlertController(title: "使い切りおめでとう！", message: "これであなたが使い切ったコスメは\(String(describing: count))個目です！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "閉じる", style: .default) { action in
            alert.dismiss(animated: true)
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //編集画面へ
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? EditViewController {
            editVC.selectedCosme = cosme
        }
    }
    
    @IBAction private func back() {
        self.dismiss(animated: true)
    }
    
}
