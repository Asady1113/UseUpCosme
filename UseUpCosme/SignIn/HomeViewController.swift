//
//  HomeViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/28.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSignIn" {
            let next = segue.destination as! SignInViewController
            if let sheet = next.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 55.0
            }
        } else if segue.identifier == "toSignUp" {
            let next = segue.destination as! SignUpViewController
            if let sheet = next.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 55.0
            }
        }
    }
   

}
