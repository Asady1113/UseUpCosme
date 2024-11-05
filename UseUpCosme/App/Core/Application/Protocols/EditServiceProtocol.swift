//
//  EditServiceProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/30.
//

import UIKit

protocol EditServiceProtocol {
    func setSelectedImageData(selectedImage: UIImage?)
    func isSelectedSameCategory(_ senderTag: Int) -> Bool
    func setSelectedCategoryNum(_ senderTag: Int)
    func validateInputData(cosmeName: String?, startDateText: String?, limitDateText: String?) -> (isError: Bool, errorMessage: String?)
    func getSelectdImagaData() -> Data?
    func parseDate(startDateText: String, limitDateText: String) -> (startDate: Date, limitDate: Date)
    func validateDate(startDate: Date, limitDate: Date) -> (isError: Bool, errorMessage: String?)
    func editNotification(notificationId: String, cosmeName: String, limitDate: Date, completion: ((Result<Void, Error>) -> Void)?)
    func deleteSelectedCosme(objectId: String, notificationId: String, completion: ((Result<Void, Error>) -> Void)?)
}
