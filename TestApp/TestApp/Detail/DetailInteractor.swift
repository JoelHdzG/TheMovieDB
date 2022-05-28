//
//  DetailInteractor.swift
//  TestApp
//
//  Created by jehernandezg on 16/05/22.
//

import Foundation

protocol DetailInteractorProtocol {
    func fetchDetail(itemId: Int, detail: detailType, onSuccess: @escaping (_ model: ShowDetail?) -> Void, onError: @escaping (_ message: String) -> Void)
    var producers : [Production_companies]? { get }
}

final class DetailInteractor: DetailInteractorProtocol, DataManagerProtocol {
    var urlDomain = DataManagerConstans.urlDomain
    var apiKey = DataManagerConstans.apiKey
    var page = DataManagerConstans.page
    
    var dataSource = [Production_companies]()
    var producers: [Production_companies]? {
        return dataSource
    }
    
    func fetchDetail(itemId: Int, detail: detailType, onSuccess: @escaping (_ model: ShowDetail?) -> Void, onError: @escaping (_ message: String) -> Void) {
        let url = getShowsDetailURL(detail: detail, showId: itemId)
        fetchData(model: ShowDetail.self, urlPath: url) { result in
            switch result {
            case .failure(let error):
                onError(error.localizedDescription)
                break
            case .success(let response):
                if let data = response.production_companies {
                    self.dataSource = data
                }
                onSuccess(response)
                break
            }
        }
    }
}
