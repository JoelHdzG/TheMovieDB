//
//  DetailModule.swift
//  TestApp
//
//  Created by jehernandezg on 16/05/22.
//

import Foundation
import UIKit

protocol DetailInputProtocol {
    var dType: detailType {get set}
    var itemId: Int {get set}
}

final class DetailModule {

    private let presenter: DetailPresenterProtocol
    
    init(with baseViewController: UINavigationController, input: DetailInputProtocol) {
        let interactor = DetailInteractor()
        let wireframe = DetailWireframe(baseController: baseViewController)
        presenter = DetailPresenter(wireframe: wireframe, interactor: interactor, input: input)
    }
    
    func showDetail() {
        presenter.showDetail()
    }
}

struct DetailInput: DetailInputProtocol {
    var dType: detailType
    var itemId: Int
    
    init(with dType: detailType, itemId: Int) {
        self.dType = dType
        self.itemId = itemId
    }
}
