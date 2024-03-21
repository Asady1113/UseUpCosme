//
//  ViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/27.
//

import UIKit
import KRProgressHUD

class MainHomeViewController: UIViewController {
    private var cosmes = [CosmeModel]()
    private var selectedCategory = "all"
    private var isOrdered = false
    @IBOutlet private weak var listTableView: UITableView!
    
    @IBOutlet private weak var clockButton: UIButton!
    @IBOutlet private weak var foundationButton: UIButton!
    @IBOutlet private weak var lipButton: UIButton!
    @IBOutlet private weak var cheekButton: UIButton!
    @IBOutlet private weak var mascaraButton: UIButton!
    @IBOutlet private weak var eyebrowButton: UIButton!
    @IBOutlet private weak var eyelinerButton: UIButton!
    @IBOutlet private weak var eyeshadowButton: UIButton!
    @IBOutlet private weak var skincareButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCosme()
    }
    
    // UI
    private func configureUI() {
        // ボタンに写真をセット
        DesignView.setImage(images: [UIImage(named: "clock.png"), UIImage(named: "foundation.png"), UIImage(named: "lip.png"), UIImage(named: "cheek.png"), UIImage(named: "mascara.png"), UIImage(named: "eyebrow.png"), UIImage(named: "eyeliner.png"), UIImage(named: "eyeshadow.png"), UIImage(named: "skincare.png")], buttons: [clockButton, foundationButton, lipButton, cheekButton, mascaraButton, eyebrowButton, eyelinerButton,eyeshadowButton, skincareButton])
        setUpTableView()
    }
    
    private func setUpTableView() {
        listTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "CosmeTableViewCell", bundle: Bundle.main)
        listTableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndex = listTableView.indexPathForSelectedRow, let detailVC = segue.destination as? DetailViewController {
            detailVC.setCosme(cosmes[selectedIndex.row])
        }
    }
    
    //ボタンによる操作（カテゴリーや期限順）
    @IBAction private func options(_sender: UIButton) {
        if _sender.tag == 8 {
            isOrdered = true
            loadCosme()
        } else {
            let category = ["ファンデーション","口紅","チーク","マスカラ","アイブロウ","アイライナ-","アイシャドウ","スキンケア"]
            selectedCategory = category[_sender.tag]
            loadCosme()
        }
    }
    
    private func loadCosme() {
        KRProgressHUD.show()
        // 使い切られていないコスメを読み込む
        RealmManager.loadCosme(selectedCategory: selectedCategory, useup: false) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(var cosmes):
                // 期限が近い順に並び替える
                if self.isOrdered == true {
                    self.cosmes = self.sortCosmeModelsByLimitDate(cosmes: cosmes)
                } else {
                    self.cosmes = cosmes
                }
                self.listTableView.reloadData()
                KRProgressHUD.dismiss()
            case .failure(let error):
                KRProgressHUD.showError(withMessage: "読み込みに失敗しました")
            }
        }
    }
    
    // 期限が近い順に並べる関数
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
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: CosmeTableViewCell, indexPath: IndexPath) {
        cell.nameLabel.text = cosmes[indexPath.row].cosmeName
        
        let startDateString = Date.stringFromDate(date: cosmes[indexPath.row].startDate, format: "yyyy / MM / dd")
        let limitDateString = Date.stringFromDate(date: cosmes[indexPath.row].limitDate, format: "yyyy / MM / dd")
        cell.startDateLabel.text = startDateString
        cell.LimitDateLabel.text = limitDateString
        
        let countDate = Date.dateToLimitDate(limitDate: cosmes[indexPath.row].limitDate)
        cell.countLabel.text = String(countDate)
        // 残り日数に応じてセルの色を変える
        DesignView.changeCountColor(count: countDate, view: cell.countView)
        
        // 画像取得
        let data = cosmes[indexPath.row].imageData
        let image = UIImage(data: data)
        cell.cosmeImageView.image = image
        
        print(cosmes[indexPath.row].objectId,"aaaa")
    }
}

extension MainHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
