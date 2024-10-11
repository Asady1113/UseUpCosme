//
//  ViewController.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/07/27.
//

import UIKit
import KRProgressHUD

class MainHomeViewController: UIViewController {
    private var cosmesListService: CosmesListServiceProtocol!
    private var cosmesListView: CosmesListViewProtocol!
    // 全権取得したコスメ
    private var allCosmes = [CosmeModel]()
    // 表示用のコスメ
    private var displayedCosmes = [CosmeModel]()
    
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
        di()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCosmes()
    }
    
    // TODO: もっといいDIのやり方ありそう
    private func di() {
        cosmesListService = CosmesListService()
        cosmesListView = CosmesListView(tableView: listTableView, optionButtons: getOptionButtons())
    }
    
    private func getOptionButtons() -> [UIButton] {
        return [
            clockButton, foundationButton, lipButton,
            cheekButton, mascaraButton, eyebrowButton,
            eyelinerButton, eyeshadowButton, skincareButton
        ]
    }
    
    // TODO: UIもいい感じに変更
    private func configureUI() {
        cosmesListView.setUpTableView(nibName: "CosmeTableViewCell", id: "Cell")
        cosmesListView.initOptionButtonImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndex = listTableView.indexPathForSelectedRow, let detailVC = segue.destination as? DetailViewController {
            detailVC.setCosme(displayedCosmes[selectedIndex.row])
        }
    }
    
    @IBAction private func changeDisplayedCosmesByOptionBtn(_sender: UIButton) {
        if cosmesListService.isSelectedSameOption(_sender.tag) {
            displayedCosmes = allCosmes
            self.cosmesListView.reloadTableView()
            cosmesListView.initOptionButtonImage()
            return
        }
        
        let nextDisplayedCosmes = cosmesListService.getDisplayedCosmesByOption(_sender.tag, prevDisplayedCosmes: displayedCosmes, allCosmes: allCosmes)
        displayedCosmes = nextDisplayedCosmes
        self.cosmesListView.reloadTableView()
        cosmesListView.updateSelectedOptionButtonImage(at: _sender.tag)
    }
    
    private func fetchCosmes() {
        KRProgressHUD.show()
        cosmesListService.fetchCosmes(isUsedUp: false) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let cosmes):
                self.allCosmes = cosmes
                self.displayedCosmes = allCosmes
                self.cosmesListView.reloadTableView()
            case .failure(let error):
                KRProgressHUD.showError(withMessage: "読み込みに失敗しました")
            }
            KRProgressHUD.dismiss()
        }
    }
}

extension MainHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCosmes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CosmeTableViewCell else {
            fatalError()
        }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: CosmeTableViewCell, indexPath: IndexPath) {
        cell.nameLabel.text = displayedCosmes[indexPath.row].cosmeName
        
        let startDateString = Date.stringFromDate(date: displayedCosmes[indexPath.row].startDate, format: "yyyy / MM / dd")
        let limitDateString = Date.stringFromDate(date: displayedCosmes[indexPath.row].limitDate, format: "yyyy / MM / dd")
        cell.startDateLabel.text = startDateString
        cell.LimitDateLabel.text = limitDateString
        
        let countDate = Date.dateToLimitDate(limitDate: displayedCosmes[indexPath.row].limitDate)
        cell.countLabel.text = String(countDate)
        // 残り日数に応じてセルの色を変える
        DesignView.changeCountColor(count: countDate, view: cell.countView)
        
        // 画像取得
        let data = displayedCosmes[indexPath.row].imageData
        let image = UIImage(data: data)
        cell.cosmeImageView.image = image
    }
}

extension MainHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
