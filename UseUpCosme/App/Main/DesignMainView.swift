//
//  DesignMainView.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/22.
//

import UIKit

class DesignMainView {
    //残り日数で色を変える
    func changeCountColor(count: Int, view: UIView) {
        if count <= 5 {
            view.backgroundColor = UIColor(hex: "EA9C8F")
        } else if count > 5 && count <= 100 {
            view.backgroundColor = UIColor(hex: "F7C8BC")
        }
    }
}
