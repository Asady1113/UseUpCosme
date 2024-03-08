//
//  ArchaivesViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/23.
//

import UIKit
import KRProgressHUD

class ArchaivesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    //var function = NCMBFunction()
    var cosmes = [Cosme]()
    var selectedCategory: String = "ALL"
    var isOrdered: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "UseUpCosmeTableViewCell", bundle: Bundle.main)
        listTableView.register(nib, forCellReuseIdentifier: "UseUpCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCosme()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cosmes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UseUpCell") as! UseUpCosmeTableViewCell
        
        cell.nameLabel.text = cosmes[indexPath.row].name
        
        let startDateString = DateUtils.dateToString(dateString: cosmes[indexPath.row].startDate, format: "yyyy / MM / dd")
        let limitDateString = DateUtils.dateToString(dateString: cosmes[indexPath.row].limitDate, format: "yyyy / MM / dd")

        cell.startDateLabel.text = startDateString
        cell.LimitDateLabel.text = limitDateString
        
        cell.useupYearLabel.text = DateUtils.dateToString(dateString: cosmes[indexPath.row].useupDate!, format: "yyyy")
        cell.useupDateLabel.text = DateUtils.dateToString(dateString: cosmes[indexPath.row].useupDate!, format: "MM/dd")
        
        let imageUrl = cosmes[indexPath.row].imageUrl
        cell.cosmeImageView.kf.setImage(with: URL(string: imageUrl!))
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //ボタンによる操作（カテゴリーや終了日順）
    @IBAction func options(_sender: UIButton) {
        if _sender.tag == 8 {
            isOrdered = true
            loadCosme()
        } else {
            let category: [String] = ["ファンデーション","口紅","チーク","マスカラ","アイブロウ","アイライナ-","アイシャドウ","スキンケア"]
            selectedCategory = category[_sender.tag]
            loadCosme()
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
        //使い切られているもの
        query?.whereKey("useup", equalTo: true)

        //カテゴリー縛りがあれば
        if selectedCategory != "ALL" {
            query?.whereKey("category", equalTo: selectedCategory)
        }
        //期限順なら
        if isOrdered == true {
            query?.order(byAscending: "useupDate")
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
                    let useup = object.object(forKey: "useup") as! Bool
                    let useupDate = object.object(forKey: "useupDate") as! Date

                    let cosme = Cosme(user: user, name: name, category: category, startDate: startDate, limitDate: limitDate, notificationId: notificationId, useup: useup)
                    cosme.objectId = object.objectId
                    cosme.imageUrl = imageUrl
                    cosme.useupDate = useupDate

                    self.cosmes.append(cosme)
                }

                KRProgressHUD.dismiss()
                self.listTableView.reloadData()
            }
        })
    }
  
}
