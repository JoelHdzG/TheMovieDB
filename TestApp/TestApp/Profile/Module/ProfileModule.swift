//
//  ProfileModule.swift
//  TestApp
//
//  Created by jehernandezg on 17/05/22.
//

import Foundation
import UIKit

final class ProfileModule {

    private let presenter: ProfilePresenterProtocol
    
    init(with baseViewController: UINavigationController) {
        let interactor = ProfileInteractor()
        let wireframe = ProfileWireframe(baseController: baseViewController)
        presenter = ProfilePresenter(wireframe: wireframe, interactor: interactor)
    }
    
    func showProfile() {
        presenter.showProfile()
    }
}
