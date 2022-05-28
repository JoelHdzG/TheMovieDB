//
//  HomeModule.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import Foundation
import UIKit

final class HomeModule {
    private let presenter: HomePresenterProtocol
    
    init(with baseViewController: UINavigationController) {
        let interactor = HomeInteractor()
        let wireframe = HomeWireframe(baseController: baseViewController)
        presenter = HomePresenter(wireframe: wireframe, interactor: interactor)
    }
    
    func showHome() {
        presenter.showHome()
    }
}
