//
//  LoginModule.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import Foundation
import UIKit

final class LoginModule {

    private let presenter: LoginPresenterProtocol
    private var wireframe: LoginWireframeProtocol
    
    init() {
        let interactor = LoginInteractor()
        wireframe = LoginWireframe()
        presenter = LoginPresenter(wireframe: wireframe, interactor: interactor)
    }
    
    func showLogin() -> UIViewController {
        presenter.showLogin()
    }
    
    func setNavigation(navigation: UINavigationController) {
        wireframe.navigation = navigation
    }
}
