//
//  AddServiceProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/11.
//

import UIKit

protocol AddServiceProtocol {
    func isSelectedSameCategory(_ senderTag: Int) -> Bool
    func setSelectedCategoryNum(_ senderTag: Int)
    func getSelectedCategory() -> CosmeCategory?
    func initSelectedCategoryNum()
    func setSelectedImageData(selectedImage: UIImage?)
    func arrangeImageToData(image: UIImage) -> Data
    func getSelectdImagaData() -> Data?
    func validateInputData(cosmeName: String?, startDateText: String?, limitDateText: String?) -> (isError: Bool, errorMessage: String?)
    func parseDate(startDateText: String, limitDateText: String) -> (startDate: Date, limitDate: Date)
    func validateDate(startDate: Date, limitDate: Date) -> (isError: Bool, errorMessage: String?)
    func createNotification(cosmeName: String, limitDate: Date, completion: ((Result<String, Error>) -> Void)?)
    func createCosmeModel(cosmeName: String, selectedCategoryString: String, selectedImageData: Data, startDate: Date, limitDate: Date, notificationId: String) -> CosmeModel
    func createCosme(cosme: CosmeModel, completion: ((Result<Void, Error>) -> Void)?)
}
