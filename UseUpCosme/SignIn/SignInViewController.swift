//
//  SignInViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/28.
//

import UIKit
import NCMB
import KRProgressHUD

class SignInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn() {
        
        if userNameTextField.text!.count > 0 && passwordTextField.text!.count > 0 {
            
            NCMBUser.logInWithUsername(inBackground: userNameTextField.text, password: passwordTextField.text) { user, error in
                if error != nil {
                    KRProgressHUD.showMessage(error!.localizedDescription)
                    
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
                    UIApplication.shared.keyWindow?.rootViewController = mainViewController

                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        }
    }
    
    //パスワード忘れ
    @IBAction func forgerPassword() {
        var alertTextField: UITextField!
        let alert = UIAlertController(title: "メールアドレスを入力してください", message: "メールアドレス認証を行なっていない場合、パスワードの変更はできません", preferredStyle: .alert)
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.returnKeyType = .done
        }
        let doneAction = UIAlertAction(title: "送信", style: .default) { action in
            //再設定用のメールを送信
            NCMBUser.requestPasswordReset(forEmail: alertTextField.text, error: nil)
            KRProgressHUD.showMessage("再設定用のメールを送信しました")
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            alert.dismiss(animated: true)
        }
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
   

}
