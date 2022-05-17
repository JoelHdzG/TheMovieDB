//
//  DetailInteractor.swift
//  TestApp
//
//  Created by jehernandezg on 16/05/22.
//

import Foundation

protocol DetailInteractorProtocol {
    func fetchDetail(itemId: Int, detail: detailType, onSuccess: @escaping (_ model: ShowDetail?) -> Void, onError: @escaping (_ message: String) -> Void)
}

final class DetailInteractor {
    let dataManager = DataManager()
}

extension DetailInteractor: DetailInteractorProtocol {
    func fetchDetail(itemId: Int, detail: detailType, onSuccess: @escaping (_ model: ShowDetail?) -> Void, onError: @escaping (_ message: String) -> Void) {
        let url = dataManager.getShowsDetailURL(detail: detail, showId: itemId)
        dataManager.fetchData(model: ShowDetail.self, urlPath: url) { result in
            switch result {
            case .failure(let error):
                onError(error.localizedDescription)
                break
            case .success(let response):
                onSuccess(response)
                break
            }
        }
    }
    

}
