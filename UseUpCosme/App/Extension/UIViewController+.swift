//
//  UIViewController+.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/03/14.
//

import UIKit
import KRProgressHUD

// imagePickerを表示する機能
extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker() {
        let actionController = UIAlertController(title: "画像の選択", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion:  nil)
            } else {
                KRProgressHUD.showMessage("この携帯ではカメラは使えません")
            }
        }
        let albumAction = UIAlertAction(title: "ライブラリから選択", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion:  nil)
            } else {
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
}
