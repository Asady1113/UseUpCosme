//
//  ViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/27.
//

import UIKit
import KRProgressHUD

class MainHomeViewController: UIViewController {
    
    @IBOutlet private weak var listTableView: UITableView!
    private var cosmes = [CosmeModel]()
    private var selectedCategory = "all"
    private var isOrdered: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCosme()
    }
    
    // UI
    private func setUpTableView() {
        listTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "CosmeTableViewCell", bundle: Bundle.main)
        listTableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndex = listTableView.indexPathForSelectedRow, let detailVC = segue.destination as? DetailViewController {
            detailVC.cosme = cosmes[selectedIndex.row]
        }
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
    
    private func loadCosme() {
        KRProgressHUD.show()
       
        RealmManager.loadCosme(selectedCategory: selectedCategory) { result in
            switch result {
            case .success(var cosmes):
                // 期限が近い順に並び替える
                if self.isOrdered == true {
                    cosmes = self.sortCosmeModelsByLimitDate(cosmes: cosmes)
                }
                self.listTableView.reloadData()
                KRProgressHUD.dismiss()
            case .failure(let error):
                KRProgressHUD.showError(withMessage: "読み込みに失敗しました")
            }
        }
    }
    
    // 機嫌順に並べる関数
    private func sortCosmeModelsByLimitDate(cosmes : [CosmeModel]) -> [CosmeModel] {
        // $0と$1にはそれぞれCosmeModelが入っている。それを比較する
        return cosmes.sorted(by: { $0.limitDate > $1.limitDate })
    }

    
}

extension MainHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cosmes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CosmeTableViewCell else {
            fatalError()
        }
        
        cell.nameLabel.text = cosmes[indexPath.row].cosmeName
        
        let startDateString = DateUtils.dateToString(dateString: cosmes[indexPath.row].startDate, format: "yyyy / MM / dd")
        let limitDateString = DateUtils.dateToString(dateString: cosmes[indexPath.row].limitDate, format: "yyyy / MM / dd")
        cell.startDateLabel.text = startDateString
        cell.LimitDateLabel.text = limitDateString
        
        let countDate = DateUtils.dateFromStartDate(limitDate: cosmes[indexPath.row].limitDate)
        cell.countLabel.text = String(countDate)
        // 残り日数に応じてセルの色を変える
        DesignMainView.changeCountColor(count: countDate, view: cell.countView)
        
        // 画像取得
        let data = cosmes[indexPath.row].imageData
        let image = UIImage(data: data)
        cell.cosmeImageView.image = image
    
        return cell
    }
}

extension MainHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
