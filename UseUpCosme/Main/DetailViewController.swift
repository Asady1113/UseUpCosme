//
//  DetailViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/22.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var cosme: Cosme!
    var selectedCategory: String!
    
    @IBOutlet weak var cosmeImageView: UIImageView!
    @IBOutlet weak var cosmeNameTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var useupDateTextField: UITextField!
    
    @IBOutlet weak var category1: UIButton!
    @IBOutlet weak var category2: UIButton!
    @IBOutlet weak var category3: UIButton!
    @IBOutlet weak var category4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cosmeImageView.kf.setImage(with: URL(string: cosme.imageUrl!))
        cosmeNameTextField.text = cosme.name
        startDateTextField.text = DateUtils.dateToString(dateString: cosme.startDate, format: "yyyy / MM / dd")
        useupDateTextField.text = DateUtils.dateToString(dateString: cosme.limitDate, format: "yyyy / MM / dd")
        
        selectedCategory = cosme.category
    }
    
    @IBAction func back() {
        self.dismiss(animated: true)
    }

    
}
