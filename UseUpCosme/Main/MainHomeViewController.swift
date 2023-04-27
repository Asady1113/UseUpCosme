//
//  ViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/27.
//

import UIKit
import NCMB
import KRProgressHUD
import Kingfisher

class MainHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    var function = NCMBFunction()
    var design = DesignMainView()
    var cosmes = [Cosme]()
    var selectedCategory: String = "ALL"
    var isOrdered: Bool = false
    
    //メールアドレス催促をしたかどうか
    var isRecommendedMailAdress: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "CosmeTableViewCell", bundle: Bundle.main)
        listTableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        function.judgeLogin()
        loadCosme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //メールアドレス認証の有無
        isRecommendedMailAdress = function.isMailAdressConfirm(view: self, isRecommendedMailAdress: isRecommendedMailAdress)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cosmes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CosmeTableViewCell
        
        cell.nameLabel.text = cosmes[indexPath.row].name
        
        let startDateString = DateUtils.dateToString(dateString: cosmes[indexPath.row].startDate, format: "yyyy / MM / dd")
        let limitDateString = DateUtils.dateToString(dateString: cosmes[indexPath.row].limitDate, format: "yyyy / MM / dd")

        cell.startDateLabel.text = startDateString
        cell.LimitDateLabel.text = limitDateString
        
        let countDate = DateUtils.dateFromStartDate(limitDate: cosmes[indexPath.row].limitDate)
        cell.countLabel.text = String(countDate)
        design.changeCountColor(count: countDate, view: cell.countView)
        
        let imageUrl = cosmes[indexPath.row].imageUrl
        cell.cosmeImageView.kf.setImage(with: URL(string: imageUrl!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex = listTableView.indexPathForSelectedRow!
        let detailVC = segue.destination as! DetailViewController
        detailVC.cosme = cosmes[selectedIndex.row]
    }
    
    
    //ボタンによる操作（カテゴリーや期限順）
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
        //使い切られていないもの
        query?.whereKey("useup", equalTo: false)

        //カテゴリー縛りがあれば
        if selectedCategory != "ALL" {
            query?.whereKey("category", equalTo: selectedCategory)
        }
        //期限順なら
        if isOrdered == true {
            query?.order(byAscending: "limitDate")
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

                    let cosme = Cosme(user: user, name: name, category: category, startDate: startDate, limitDate: limitDate, notificationId: notificationId, useup: useup)
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

