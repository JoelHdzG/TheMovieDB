//
//  LoginModule.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import Foundation
import UIKit

final class LoginModule {

    var navigation: UINavigationController
    private let presenter: LoginPresenterProtocol
    
    init() {
        let interactor = LoginInteractor()
        let wireframe = LoginWireframe()
        presenter = LoginPresenter(wireframe: wireframe, interactor: interactor)
        navigation = UINavigationController(rootViewController: presenter.showLogin())
        wireframe.navigation = navigation
    }
}
