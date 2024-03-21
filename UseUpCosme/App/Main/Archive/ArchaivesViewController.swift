//
//  ArchaivesViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/23.
//

import UIKit
import KRProgressHUD

class ArchaivesViewController: UIViewController {
    private var cosmes = [CosmeModel]()
    private var selectedCategory: String = "all"
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
    
    private func configureUI() {
        // ボタンに写真をセット
        DesignView.setImage(images: [UIImage(named: "clock2.png"), UIImage(named: "foundation.png"), UIImage(named: "lip.png"), UIImage(named: "cheek.png"), UIImage(named: "mascara.png"), UIImage(named: "eyebrow.png"), UIImage(named: "eyeliner.png"), UIImage(named: "eyeshadow.png"), UIImage(named: "skincare.png")], buttons: [clockButton, foundationButton, lipButton, cheekButton, mascaraButton, eyebrowButton, eyelinerButton,eyeshadowButton, skincareButton])
        
        setupTableView()
    }
    
    private func setupTableView() {
        listTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "UseUpCosmeTableViewCell", bundle: Bundle.main)
        listTableView.register(nib, forCellReuseIdentifier: "UseUpCell")
    }
    
    // ボタンによる操作（カテゴリーや終了日順）
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
    
    // コスメの読み込み
    private func loadCosme() {
        KRProgressHUD.show()
        cosmes = [CosmeModel]()
        // 使い切られているコスメを読み込む
        RealmManager.loadCosme(selectedCategory: selectedCategory, useup: true) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(var cosmes):
                // 使い切った日が早い順に並び替える
                if self.isOrdered == true {
                    self.cosmes = self.sortCosmeModelsByUseUpDate(cosmes: cosmes)
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
    
    // 使い切った日が早い順に並び替える
    private func sortCosmeModelsByUseUpDate(cosmes: [CosmeModel]) -> [CosmeModel] {
        return cosmes.sorted(by: { (cosme1, cosme2) in
            if let useupDate1 = cosme1.useupDate, let useupDate2 = cosme2.useupDate {
                return useupDate1 > useupDate2
            } else {
                return false
            }
        })
    }
    
}

extension ArchaivesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cosmes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UseUpCell") as? UseUpCosmeTableViewCell else {
            fatalError()
        }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: UseUpCosmeTableViewCell, indexPath: IndexPath) {
        cell.nameLabel.text = cosmes[indexPath.row].cosmeName
        
        let startDateString = Date.stringFromDate(date: cosmes[indexPath.row].startDate, format: "yyyy / MM / dd")
        let limitDateString = Date.stringFromDate(date: cosmes[indexPath.row].limitDate, format: "yyyy / MM / dd")
        cell.startDateLabel.text = startDateString
        cell.LimitDateLabel.text = limitDateString
        
        if let useupDate = cosmes[indexPath.row].useupDate {
            cell.useupYearLabel.text = Date.stringFromDate(date: useupDate, format: "yyyy")
            cell.useupDateLabel.text = Date.stringFromDate(date: useupDate, format: "MM/dd")
        }
        // 画像取得
        let data = cosmes[indexPath.row].imageData
        let image = UIImage(data: data)
        cell.cosmeImageView.image = image
    }
}

extension ArchaivesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
