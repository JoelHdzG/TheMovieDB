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
    weak var delegate: HomeViewDelegate?
    private var section: showType = .popular
    
    init(wireframe: HomeWireframeProtocol, interactor: HomeInteractorProtocol) {
        self.wireframe = wireframe
        self.interactor = interactor
    }
}

extension HomePresenter: HomePresenterProtocol {
    func saveFavorite(index: Int) {
        interactor.saveFavorite(index: index) {
            self.fetchList(section: self.section) {
                self.delegate?.updateData()
            }
        }
    }
    
    func fetchList(section: showType, onSuccess: @escaping () -> Void) {
        self.section = section
        self.wireframe.showAnimation {
            self.interactor.fetchMovieList(section: section) {
                self.wireframe.hideAnimation {
                    onSuccess()
                }
            } onError: { [weak self] message in
                guard let self = self else { return }
                self.wireframe.hideAnimation {
                    self.wireframe.showAlert(message: message)
                }
            }
        }
    }
    
    var dataSource: [Results]? {
        interactor.dataSource
    }
    
    func showDetail(itemId: Int, detailType: detailType) {
        wireframe.showDetailModule(itemId: itemId, detailType: detailType)
    }
    
    func showNavigationActionSheet() {
        wireframe.showNavigationActionSheet()
    }
    
    func showHome() {
        wireframe.showHome(with:self)
    }
}
