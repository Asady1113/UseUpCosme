//
//  SignInViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/28.
//

import UIKit
import NCMB

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
    

   

}
