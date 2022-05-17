//
//  DetailModule.swift
//  TestApp
//
//  Created by jehernandezg on 16/05/22.
//

import Foundation
import UIKit

final class DetailModule {

    private let presenter: DetailPresenterProtocol
    
    init(with baseViewController: UINavigationController, detailType: detailType, itemId: Int) {
        let interactor = DetailInteractor()
        let wireframe = DetailWireframe(baseController: baseViewController)
        presenter = DetailPresenter(wireframe: wireframe, interactor: interactor, detailType: detailType, itemId: itemId)
    }
    
    func showDetail() {
        presenter.showDetail()
    }
}
