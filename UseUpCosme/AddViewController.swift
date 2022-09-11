//
//  AddViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/08/30.
//

import UIKit
import NCMB
import KRProgressHUD
import NYXImagesKit

class AddViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let function = NCMBFunction()
    
    @IBOutlet weak var cosmeImageView: UIImageView!
    
    @IBOutlet weak var cosmeNameTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var useupDateTextField: UITextField!
    
    @IBOutlet weak var category1: UIButton!
    @IBOutlet weak var category2: UIButton!
    @IBOutlet weak var category3: UIButton!
    @IBOutlet weak var category4: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        function.judgeLogin()

        cosmeNameTextField.delegate = self
        startTextField.delegate = self
        useupDateTextField.delegate = self
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
        let resizedImage = selectedImage.scale(byFactor: 0.3)
       
        cosmeImageView.image = resizedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    

    

}
