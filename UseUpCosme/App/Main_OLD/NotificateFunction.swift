//
//  NotificateFunction.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2022/12/20.
//

import Foundation
import UserNotifications
import KRProgressHUD

class NotificateFunction {
    static func makenotification(name: String, limitDate: Date) -> String {
        // ローカル通知の内容
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "\(String(describing: name))の使用期限が残り一週間です"
        content.subtitle = "使用期限まで残り一週間のコスメがあります"
        content.body =
        "\(String(describing: name))が使用期限まで残り一週間です。今週中に使い切りましょう！"
        content.badge = 1
        
        // 日付を設定して、通知に入れる
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: limitDate)
        // idを用いて、ローカル通知リクエストを作成
        let id = UUID().uuidString
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        // ローカル通知リクエストを登録
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error {
                KRProgressHUD.showMessage(error.localizedDescription)
            }
        }
        return id
    }
    
    //通知の編集
    static func editNotification(notificationId: String, name: String, limitDate: Date) {
        // ローカル通知の内容
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "\(String(describing: name))の使用期限が残り一週間です"
        content.subtitle = "使用期限まで残り一週間のコスメがあります"
        content.body =
        "\(String(describing: name))が使用期限まで残り一週間です。今週中に使い切りましょう！"
        content.badge = 1
        
        // 日付を設定して、通知に入れる
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: limitDate)
        // ローカル通知リクエストを作成
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        // ローカル通知リクエストを登録
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error {
                KRProgressHUD.showMessage(error.localizedDescription)
            }
        }
    }
}
