//
//  DetailViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/22.
//

import UIKit
import KRProgressHUD

class DetailViewController: UIViewController {
    
    var cosme: CosmeModel!
    var selectedCategory: String!
    var useUpCosme: Int = 0
    //var function = NCMBFunction()
    
    @IBOutlet weak var cosmeImageView: UIImageView!
    @IBOutlet weak var cosmeNameTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var useupDateTextField: UITextField!
    @IBOutlet weak var useupButton: UIButton!
    
    @IBOutlet weak var category1: UIButton!
    @IBOutlet weak var category2: UIButton!
    @IBOutlet weak var category3: UIButton!
    @IBOutlet weak var category4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        design()
        
        cosmeImageView.kf.setImage(with: URL(string: cosme.imageUrl!))
        cosmeNameTextField.text = cosme.name
        startDateTextField.text = DateUtils.dateToString(dateString: cosme.startDate, format: "yyyy / MM / dd")
        useupDateTextField.text = DateUtils.dateToString(dateString: cosme.limitDate, format: "yyyy / MM / dd")
        
        selectedCategory = cosme.category
    }
    
    @IBAction func useup() {
        cosme.useup = true
        useupCosme(cosme: cosme)
    }
    
    
    func useupCosme(cosme: Cosme) {
        let query = NCMBQuery(className: "Cosme")
        query?.whereKey("objectId", equalTo: cosme.objectId)
        
        query?.findObjectsInBackground({ result, error in
            let object = result?.first as! NCMBObject
            object.setObject(cosme.useup, forKey: "useup")
            object.setObject(Date(), forKey: "useupDate")
            
            object.saveInBackground({ error in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "保存に失敗しました")
                } else {
                    self.countUseUpCosme(user: cosme.user)
                }
            })
        })
    }
    
    //使い切ったコスメの数を数える
    func countUseUpCosme(user: NCMBUser){
        let query = NCMBQuery(className: "Cosme")
        query?.whereKey("user", equalTo: user)
        query?.whereKey("useup", equalTo: true)
        
        query?.findObjectsInBackground({ [self] result, error in
            if error != nil {
                KRProgressHUD.showMessage("データの読み込みに失敗しました")
            } else {
                useUpCosme = result!.count
                
                let alert = UIAlertController(title: "使い切りおめでとう！", message: "これであなたが使い切ったコスメは\(String(describing: useUpCosme))個目です！", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "閉じる", style: .default) { action in
                    alert.dismiss(animated: true)
                    self.dismiss(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    
    //編集画面へ
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editVC = segue.destination as! EditViewController
        editVC.selectedCosme = cosme
    }
    
    @IBAction func back() {
        self.dismiss(animated: true)
    }

    
    func design() {
        useupButton.layer.cornerRadius = 7
        useupButton.clipsToBounds = true
    }
    
}
