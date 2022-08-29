//
//  AddViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/08/30.
//

import UIKit
import NCMB

class AddViewController: UIViewController,UITextFieldDelegate {
    
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

        cosmeNameTextField.delegate = self
        startTextField.delegate = self
        useupDateTextField.delegate = self
    }
    
    
    
    

    

}
