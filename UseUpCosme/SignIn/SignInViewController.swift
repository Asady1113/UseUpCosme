//
//  SignInViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/28.
//

import UIKit

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
    }
    

   

}
