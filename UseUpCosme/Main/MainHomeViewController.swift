//
//  ViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/27.
//

import UIKit
import NCMB
import KRProgressHUD

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
        //Cosmeの読み込み(モデル化断念）
//          cosmes = function.loadCosme(user: NCMBUser.current(), category: selectedCategory)
//          listTableView.reloadData()
        
        KRProgressHUD.show()

        cosmes = [Cosme]()

        let query = NCMBQuery(className: "Cosme")
        query?.includeKey("user")
        // 自分の投稿だけ持ってくる
        query?.whereKey("user", equalTo: NCMBUser.current())

        //カテゴリー縛りがあれば
        if selectedCategory != "ALL" {
            query?.whereKey("category", equalTo: selectedCategory)
        }

        query?.findObjectsInBackground({ result, error in
            if error != nil {
                KRProgressHUD.showError(withMessage: "読み込みに失敗しました")
            } else {

                for object in result as! [NCMBObject] {
                    let user = object.object(forKey: "user") as! NCMBUser
                    let name = object.object(forKey: "name") as! String
                    let category = object.object(forKey: "category") as! String
                    let startDate = object.object(forKey: "startDate") as! Date
                    let limitDate = object.object(forKey: "limitDate") as! Date
                    let imageUrl = object.object(forKey: "imageUrl") as! String
                    let notificationId = object.object(forKey: "notificationId") as! String

                    let cosme = Cosme(user: user, name: name, category: category, startDate: startDate, limitDate: limitDate, notificationId: notificationId)
                    cosme.objectId = object.objectId
                    cosme.imageUrl = imageUrl

                    self.cosmes.append(cosme)
                }

                KRProgressHUD.dismiss()
                self.listTableView.reloadData()
            }
        })
    }
}

