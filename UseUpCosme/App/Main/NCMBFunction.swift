//
//  NCMBFunction.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/09/11.
//

import Foundation
import KRProgressHUD
import UIKit

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
    
    //登録
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
                object?.setObject(cosme.useup, forKey: "useup")
                
                let url = "https://mbaas.api.nifcloud.com/2013-09-01/applications/132O6QPULPxxmgG/publicFiles/" + file.name
                
                object?.setObject(url, forKey: "imageUrl")
                
                object?.saveInBackground({ error in
                    if error != nil {
                        KRProgressHUD.showError(withMessage: "保存に失敗しました")
                    } else {
                        KRProgressHUD.dismiss()
                        KRProgressHUD.showMessage("登録が完了しました")
                    }
                })
            }
        }
    }
    
    //編集
    func editCosme(cosme: Cosme, resizedImage: UIImage) {
        KRProgressHUD.show()
        
        let query = NCMBQuery(className: "Cosme")
        query?.whereKey("objectId", equalTo: cosme.objectId)
        
        query?.findObjectsInBackground({ result, error in
            let object = result?.first as! NCMBObject
            
            let data = resizedImage.pngData()
            let file = NCMBFile.file(with: data) as! NCMBFile
            file.saveInBackground { error in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "画像の保存に失敗しました")
                } else {
                    
                    object.setObject(cosme.user, forKey: "user")
                    object.setObject(cosme.name, forKey: "name")
                    object.setObject(cosme.category, forKey: "category")
                    object.setObject(cosme.startDate, forKey: "startDate")
                    object.setObject(cosme.limitDate, forKey: "limitDate")
                    object.setObject(cosme.notificationId, forKey: "notificationId")
                    object.setObject(cosme.useup, forKey: "useup")
                    
                    let url = "https://mbaas.api.nifcloud.com/2013-09-01/applications/132O6QPULPxxmgG/publicFiles/" + file.name
                    
                    object.setObject(url, forKey: "imageUrl")
                    
                    object.saveInBackground({ error in
                        if error != nil {
                            KRProgressHUD.showError(withMessage: "保存に失敗しました")
                        } else {
                            KRProgressHUD.dismiss()
                            KRProgressHUD.showMessage("登録が完了しました")
                        }
                    })
                }
            }
        })
    }
    
    
    //使い切り（モデル化失敗）
    func useupCosme(cosme: Cosme) -> Int {
        let query = NCMBQuery(className: "Cosme")
        query?.whereKey("objectId", equalTo: cosme.objectId)
        
        query?.findObjectsInBackground({ result, error in
            let object = result?.first as! NCMBObject
            object.setObject(cosme.useup, forKey: "useup")
            
            object.saveInBackground({ error in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "保存に失敗しました")
                }
            })
        })
        
        let useUpCosme = countUseUpCosme(user: cosme.user)
        return useUpCosme
    }
    
    //使い切ったコスメの数を数える（モデル化失敗）
    func countUseUpCosme(user: NCMBUser) -> Int {
        var useUpCosme: Int = 0
        
        let query = NCMBQuery(className: "Cosme")
        query?.whereKey("user", equalTo: user)
        query?.whereKey("useup", equalTo: true)
        
        query?.findObjectsInBackground({ result, error in
            if error != nil {
                KRProgressHUD.showMessage("データの読み込みに失敗しました")
            } else {
                useUpCosme = result!.count
            }
        })
        
        return useUpCosme
    }
    
    
    //コスメ読み込み（非同期処理できず、モデル化断念）
    func loadCosme(user: NCMBUser,category: String) -> [Cosme] {
        KRProgressHUD.show()
        
        var cosmes = [Cosme]()
        
        let query = NCMBQuery(className: "Cosme")
        query?.includeKey("user")
        // 自分の投稿だけ持ってくる
        query?.whereKey("user", equalTo: user)
        
        //カテゴリー縛りがあれば
        if category != "ALL" {
            query?.whereKey("category", equalTo: category)
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
                    
                    let cosme = Cosme(user: user, name: name, category: category, startDate: startDate, limitDate: limitDate, notificationId: notificationId,useup: useup)
                    cosme.objectId = object.objectId
                    cosme.imageUrl = imageUrl
                    
                    cosmes.append(cosme)
                }
                
                KRProgressHUD.dismiss()
            }
        })
        return cosmes
    }
}
