//
//  UseUpCosmeTableViewCell.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/23.
//

import UIKit

class UseUpCosmeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var useupYearLabel: UILabel!
    @IBOutlet weak var useupDateLabel: UILabel!
    @IBOutlet weak var cosmeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var LimitDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        configureView(view: countView)
        configureImageView(imageView: cosmeImageView)
        configureLabel(label: startLabel)
        configureLabel(label: limitLabel)
        configureDateLabel(label: startDateLabel)
        configureDateLabel(label: LimitDateLabel)
    }
    
    private func configureView(view: UIView) {
        view.layer.cornerRadius = 6
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.clipsToBounds = true
    }
    
    private func configureImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = 6
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        imageView.clipsToBounds = true
    }
    
    private func configureLabel(label: UILabel) {
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
    }
    
    private func configureDateLabel(label: UILabel) {
        label.layer.cornerRadius = 6
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        label.clipsToBounds = true
    }

}
