//
//  DetailPresenter.swift
//  TestApp
//
//  Created by jehernandezg on 16/05/22.
//

import Foundation

protocol DetailPresenterProtocol: DetailViewOutput {
    func showDetail()
}

final class DetailPresenter {
    private let wireframe: DetailWireframeProtocol
    private let interactor: DetailInteractorProtocol
    private let input: DetailInputProtocol
    
    init(wireframe: DetailWireframeProtocol, interactor: DetailInteractorProtocol, input: DetailInputProtocol) {
        self.wireframe = wireframe
        self.interactor = interactor
        self.input = input
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func getDetail(onSuccess: @escaping (_ model: ShowDetail?) -> Void) {
        wireframe.showAnimation {
            self.interactor.fetchDetail(itemId: self.input.itemId, detail: self.input.dType) { [weak self] model in
                guard let self = self else { return }
                self.wireframe.hideAnimation {
                    onSuccess(model)
                }
            } onError: { [weak self] message in
                guard let self = self else { return }
                self.wireframe.hideAnimation {
                    self.wireframe.showAlert(message: message)
                }
            }

        }
    }
    
    func showDetail() {
        wireframe.showDetail(with:self)
    }
    
    func getProducers() -> [Production_companies]? {
        interactor.producers
    }
    
    func showTrailer() {
        wireframe.showTrailer()
    }
}
