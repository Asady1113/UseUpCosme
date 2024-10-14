//
//  AddService.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/11.
//

import Foundation
import UserNotifications

class AddService: AddServiceProtocol {
    private let realmManagerProtocol: RealmManagerProtocol = RealmManager()
    private var selectedCategoryNum: Int?
    
    func isSelectedSameCategory(_ senderTag: Int) -> Bool {
        if selectedCategoryNum == senderTag {
            selectedCategoryNum = nil
            return true
        }
        return false
    }
    
    func setSelectedCategoryNum(_ senderTag: Int) {
        selectedCategoryNum = senderTag
    }
    
    func getSelectedCategory() -> CosmeCategory? {
        let category: [CosmeCategory] = [
            .foundation,
            .lip,
            .cheek,
            .mascara,
            .eyebrow,
            .eyeliner,
            .eyeshadow,
            .skincare
        ]
        
        guard let selectedCategoryNum else {
            return nil
        }
        return category[selectedCategoryNum]
    }
    
    func initSelectedCategoryNum() {
        selectedCategoryNum = nil
    }
    
    func validateInputData(selectedImageDate: Data?, cosmeName: String?, startDateText: String?, limitDateText: String?) -> (isError: Bool, errorMessage: String?) {
        guard let selectedImageDate else {
            return (true, "画像を登録してください")
        }
        if cosmeName == "" {
            return (true, "名前を登録してください")
        }
        if startDateText == "" {
            return (true, "使用開始日を登録してください")
        }
        if limitDateText == "" {
            return (true, "使用期限を登録してください")
        }
        let selectedCategory = getSelectedCategory()
        guard let selectedCategory else {
            return (true, "カテゴリを登録してください")
        }
        return (false, nil)
    }
    
    func parseDate(startDateText: String, limitDateText: String) -> (startDate: Date, limitDate: Date) {
        let startDate = Date.dateFromString(string: startDateText, format: "yyyy / MM / dd")
        let limitDate = Date.dateFromString(string: limitDateText, format: "yyyy / MM / dd")
        
        return (startDate, limitDate)
    }
    
    func validateDate(startDate: Date, limitDate: Date) -> (isError: Bool, errorMessage: String?) {
        // 使用期限と本日の差分)
        let dateSubtractionFromToday = Int(limitDate.timeIntervalSince(Date()))
        // 使用期限と使用開始日の差分
        let dateSubtractionFromStart = Int(limitDate.timeIntervalSince(startDate))
        
        if dateSubtractionFromToday < 0 {
            return (true,"すでに期限が切れているようです")
        } else if dateSubtractionFromStart < 0 {
            return (true,"使用開始時に期限が切れているようです")
        }
        return (false, nil)
    }
    
    func createNotification(cosmeName: String, limitDate: Date, completion: ((Result<String, Error>) -> Void)?) {
        // ローカル通知の内容
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "\(String(describing: cosmeName))の使用期限が残り一週間です"
        content.subtitle = "使用期限まで残り一週間のコスメがあります"
        content.body =
        "\(String(describing: cosmeName))が使用期限まで残り一週間です。今週中に使い切りましょう！"
        content.badge = 1
        
        // 日付を設定して、通知に入れる
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: limitDate)
        // idを用いて、ローカル通知リクエストを作成
        let notificationId = UUID().uuidString
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        // ローカル通知リクエストを登録
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error {
                completion?(.failure(error))
            }
        }
        completion?(.success((notificationId)))
    }
    
    func createCosmeModel(cosmeName: String, selectedCategoryString: String, selectedImageData: Data, startDate: Date, limitDate: Date, notificationId: String) -> CosmeModel {
        let cosme = CosmeModel(cosmeName: cosmeName, category: selectedCategoryString, startDate: startDate, limitDate: limitDate, imageData: selectedImageData, notificationId: notificationId, useup: false)
        
        return cosme
    }
    
    func createCosme(cosme: CosmeModel, completion: ((Result<Void, Error>) -> Void)?) {
        realmManagerProtocol.createCosme(cosme: cosme) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success():
                completion?(.success(()))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
