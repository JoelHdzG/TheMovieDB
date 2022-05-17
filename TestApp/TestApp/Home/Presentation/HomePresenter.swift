//
//  HomePresenter.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import Foundation

protocol HomePresenterProtocol: HomeViewOutput {
    func showHome()
}

final class HomePresenter {
    private let wireframe: HomeWireframeProtocol
    private let interactor: HomeInteractorProtocol
    
    init(wireframe: HomeWireframeProtocol, interactor: HomeInteractorProtocol) {
        self.wireframe = wireframe
        self.interactor = interactor
    }
}

extension HomePresenter: HomePresenterProtocol {
    func showDetail(itemId: Int, detailType: detailType) {
        wireframe.showDetailModule(itemId: itemId, detailType: detailType)
    }
    
    func fetchList(section: showType, onSuccess: @escaping (_ model: [Results]?) -> Void) {
        wireframe.showAnimation {
            self.interactor.fetchMovieList(section: section) { [weak self] model in
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
    
    func showNavigationActionSheet() {
        wireframe.showNavigationActionSheet()
    }
    
    func showHome() {
        wireframe.showHome(with:self)
    }
}
