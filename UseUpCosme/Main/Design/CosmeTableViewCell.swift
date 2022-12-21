//
//  CosmeTableViewCell.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/20.
//

import UIKit

class CosmeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var cosmeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var LimitDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        countView.layer.cornerRadius = 6
        countView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        countView.clipsToBounds = true
        
        cosmeImageView.layer.cornerRadius = 6
        cosmeImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        cosmeImageView.clipsToBounds = true
        
        startLabel.layer.cornerRadius = 6
        startLabel.clipsToBounds = true
        
        limitLabel.layer.cornerRadius = 6
        limitLabel.clipsToBounds = true
        
        startDateLabel.layer.cornerRadius = 6
        startDateLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        startDateLabel.clipsToBounds = true
        
        LimitDateLabel.layer.cornerRadius = 6
        LimitDateLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        LimitDateLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
