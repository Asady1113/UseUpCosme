//
//  ViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/27.
//

import UIKit
import NCMB

class MainHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    var function = NCMBFunction()
    var cosmes = [Cosme]()
    var selectedCategory: String = "ALL"
    var isOrdered: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        let nib = UINib(nibName: "CosmeTableViewCell", bundle: Bundle.main)
        listTableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCosme()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cosmes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CosmeTableViewCell
        
        return cell
    }
    
    
    @IBAction func options(_sender: UIButton) {
        if _sender.tag == 8 {
            isOrdered = true
        } else {
            let category: [String] = ["ファンデーション","口紅","チーク","マスカラ","アイブロウ","アイライナ-","アイシャドウ","スキンケア"]
            selectedCategory = category[_sender.tag]
        }
    }
    
    
    func loadCosme() {
        //Cosmeの読み込み
        cosmes = function.loadCosme(user: NCMBUser.current(), category: selectedCategory)
        listTableView.reloadData()
    }
}

