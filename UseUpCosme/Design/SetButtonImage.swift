//
//  SetButtonImage.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/01.
//

import UIKit

class SetButtonImage {
    
    func setImage(button: UIButton) {
        //画像をセット
        let picture = UIImage(named: "foundation.png")
        button.setImage(picture, for: .normal)
    }
}
