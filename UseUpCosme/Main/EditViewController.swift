//
//  EditViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/26.
//

import UIKit
import NCMB
import KRProgressHUD
import NYXImagesKit
import Kingfisher

class EditViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let function = NCMBFunction()
    let design = DesignAddView()
    var resizedImage: UIImage!
    
    var selectedCosme: Cosme!
    var selectedCategory: String!
    
    @IBOutlet weak var cosmeImageView: UIImageView!
    @IBOutlet weak var pencilImageView: UIImageView!
    
    @IBOutlet weak var cosmeNameTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var useupDateTextField: UITextField!
    
    @IBOutlet weak var category1: UIButton!
    @IBOutlet weak var category2: UIButton!
    @IBOutlet weak var category3: UIButton!
    @IBOutlet weak var category4: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        function.judgeLogin()
        //ボタンに写真をセット(カテゴリー1のみ）
        design.setImage(button: category1)
        //pickerの設定
        design.makeDatePicker(startDateTextField: startDateTextField, useupDateTextField: useupDateTextField, view: view)
        //鉛筆の画像を丸くする
        design.designImage(image: pencilImageView)

        cosmeNameTextField.delegate = self
        startDateTextField.delegate = self
        useupDateTextField.delegate = self
        
        //情報の表示
        cosmeImageView.kf.setImage(with: URL(string: selectedCosme.imageUrl!))
        resizedImage = cosmeImageView.image
        cosmeNameTextField.text = selectedCosme.name
        startDateTextField.text = DateUtils.dateToString(dateString: selectedCosme.startDate, format: "yyyy / MM / dd")
        useupDateTextField.text = DateUtils.dateToString(dateString: selectedCosme.limitDate, format: "yyyy / MM / dd")
        
        selectedCategory = selectedCosme.category
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func selectImage(){
        let actionController = UIAlertController(title: "画像の選択", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = self
                    self.present(picker, animated: true, completion:  nil)
            }else{
                    KRProgressHUD.showMessage("この携帯ではカメラは使えません")
                           
                  }
        }
        
        let albumAction = UIAlertAction(title: "ライブラリから選択", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    self.present(picker, animated: true, completion:  nil)
            }else{
                    KRProgressHUD.showMessage("この携帯ではアルバムは使えません")
                       
                   }
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
       
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
        
    }
    
    //PickerViewに写真を表示する
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        resizedImage = selectedImage.scale(byFactor: 0.3)
       
        cosmeImageView.image = resizedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    //カテゴリ選択関数
    @IBAction func selectCategory(_sender: UIButton) {
        
        let category: [String] = ["ファンデーション","口紅","チーク","マスカラ","アイブロウ","アイライナ-","アイシャドウ","スキンケア"]
        selectedCategory = category[_sender.tag]
    }
    
    
    @IBAction func add() {
        
        if cosmeImageView.image == UIImage(named: "default-placeholder") {
            KRProgressHUD.showError(withMessage: "画像を登録してください")
            
        } else if cosmeNameTextField.text?.count == 0{
            KRProgressHUD.showError(withMessage: "名前を登録してください")
        } else if startDateTextField.text?.count == 0{
            KRProgressHUD.showError(withMessage: "使用開始日を登録してください")
        } else if useupDateTextField.text?.count == 0 {
            KRProgressHUD.showError(withMessage: "使用期限を登録してください")
        } else if selectedCategory == nil {
            KRProgressHUD.showError(withMessage: "カテゴリを登録してください")
        } else {
            //画像調整
            UIGraphicsBeginImageContext(resizedImage.size)
            let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
            resizedImage.draw(in: rect)
            resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //日付をDate型に変換する
            let startDate = DateUtils.stringToDate(dateString: startDateTextField.text!, fromFormat: "yyyy / MM / dd")!
            let limitDate = DateUtils.stringToDate(dateString: useupDateTextField.text!, fromFormat: "yyyy / MM / dd")!
            
            //設定日付が正しいかを判定
            let dateSubtractionFromToday = Int(limitDate.timeIntervalSince(Date()))
            let dateSubtractionFromStart = Int(limitDate.timeIntervalSince(startDate))
            
            print(dateSubtractionFromStart)
            if dateSubtractionFromToday < 0 {
                KRProgressHUD.showError(withMessage: "すでに期限が切れているようです")
                return
            } else if dateSubtractionFromStart < 0 {
                KRProgressHUD.showError(withMessage: "使用開始時に期限が切れているようです")
                return
            }
            
            //通知設定（まだ）
            let notificateFunc = NotificateFunction()
            let notificationId = notificateFunc.makenotification(name: cosmeNameTextField.text!, limitDate: limitDate)
            
            //モデル化
            let cosme = Cosme(user: NCMBUser.current(), name: cosmeNameTextField.text!, category: selectedCategory, startDate: startDate, limitDate: limitDate, notificationId: notificationId, useup: false)
            cosme.objectId = selectedCosme.objectId
            
            //追加
            function.editCosme(cosme: cosme, resizedImage: resizedImage)
            
            //元の画面へ
            self.dismiss(animated: true)
        }
    }
    
    
    @IBAction func back() {
        self.dismiss(animated: true)
    }
}
