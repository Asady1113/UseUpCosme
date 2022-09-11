//
//  NCMBFunction.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/09/11.
//

import Foundation
import NCMB

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
    
    
    
}
