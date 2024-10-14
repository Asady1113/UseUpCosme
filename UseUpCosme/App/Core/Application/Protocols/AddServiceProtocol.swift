//
//  AddServiceProtocol.swift
//  UseUpCosme
//
//  Created by 浅田智哉 on 2024/10/11.
//

import Foundation

protocol AddServiceProtocol {
    func isSelectedSameCategory(_ senderTag: Int) -> Bool
    func setSelectedCategoryNum(_ senderTag: Int)
    func getSelectedCategory() -> CosmeCategory?
    func initSelectedCategoryNum()
    func validateInputData(selectedImageDate: Data?, cosmeName: String?, startDateText: String?, limitDateText: String?) -> (isError: Bool, errorMessage: String?)
    func parseDate(startDateText: String, limitDateText: String) -> (startDate: Date, limitDate: Date)
    func validateDate(startDate: Date, limitDate: Date) -> (isError: Bool, errorMessage: String?)
    func createCosmeModel(cosmeName: String, selectedCategoryString: String, selectedImageData: Data, startDate: Date, limitDate: Date) -> CosmeModel
    func createCosme(cosme: CosmeModel, completion: ((Result<Void, Error>) -> Void)?)
}
