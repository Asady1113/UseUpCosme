//
//  NCMBFunction.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/09/11.
//

import Foundation
import NCMB
import KRProgressHUD

class NCMBFunction {
    
    func judgeLogin() {
        
        guard let currentUser = NCMBUser.current() else{
            //ログアウト成功
            let storyboard = UIStoryboard(name: "SignIn",bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            //ログイン情報の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            return
        }
        
    }
    
    func addCosme(cosme: Cosme, resizedImage: UIImage) {
        KRProgressHUD.show()
        
        let data = resizedImage.pngData()
        let file = NCMBFile.file(with: data) as! NCMBFile
        file.saveInBackground { error in
            if error != nil {
                KRProgressHUD.showError(withMessage: "画像の保存に失敗しました")
            } else {
                let object = NCMBObject(className: "Cosme")
                
                object?.setObject(cosme.user, forKey: "user")
                object?.setObject(cosme.name, forKey: "name")
                object?.setObject(cosme.category, forKey: "category")
                object?.setObject(cosme.startDate, forKey: "startDate")
                object?.setObject(cosme.limitDate, forKey: "limitDate")
                object?.setObject(cosme.notificationId, forKey: "notificationId")
                
                let url = "https://mbaas.api.nifcloud.com/2013-09-01/applications/132O6QPULPxxmgG/publicFiles/" + file.name
                
                object?.setObject(url, forKey: "imageUrl")
                
                object?.saveInBackground({ error in
                    if error != nil {
                        KRProgressHUD.showError(withMessage: "保存に失敗しました")
                    } else {
                        KRProgressHUD.dismiss()
                    }
                })
            }
        }
    }
}
