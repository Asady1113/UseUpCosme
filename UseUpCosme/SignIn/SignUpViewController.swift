//
//  SignUpViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/28.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func signUp() {
        
        let user = NCMBUser()
        
        if userNameTextField.text!.count <= 3 {
            print("ユーザー名の文字数が足りません")
            return
        }
        
        if passwordTextField.text!.count <= 3 {
            print("パスワードの文字数が足りません")
            return
        }
        
        if emailTextField.text!.count == 0 {
            print("メールアドレスが入力されていません")
            return
        }
    
        user.mailAddress = emailTextField.text
        user.userName = userNameTextField.text
        user.password = passwordTextField.text
        
        
        user.signUpInBackground { error in
            if error != nil {
                print("サインイン失敗")
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
