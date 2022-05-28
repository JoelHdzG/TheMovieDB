//
//  LoginPresenter.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import Foundation
import UIKit

protocol LoginPresenterProtocol: LoginViewOutput {
    func showLogin() -> UIViewController
}

final class LoginPresenter {
    weak var delegate: LoginViewDelegate?
    private let wireframe: LoginWireframeProtocol
    private let interactor: LoginInteractorProtocol
    
    init(wireframe: LoginWireframeProtocol, interactor: LoginInteractorProtocol) {
        self.wireframe = wireframe
        self.interactor = interactor
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func showHome() {
        wireframe.showHomeModule()
    }
    
    func setLogin(user: String?, password: String?) {
        wireframe.showAnimation {
            if user?.count == 0 {
                self.wireframe.hideAnimation {
                    self.wireframe.showAlert(message: "Ingresa tu usuario")
                    return
                }
            }
            if password?.count == 0  {
                self.wireframe.hideAnimation {
                    self.wireframe.showAlert(message: "Ingresa tu contraseña")
                    return
                }
            }
            self.interactor.fetchLogin(user: user ?? "", password: password ?? "") {
                self.wireframe.hideAnimation {
                    self.wireframe.showHomeModule()
                    self.delegate?.willShowLoginError(success: true)
                }
            } onError: {
                self.wireframe.hideAnimation {
                    self.delegate?.willShowLoginError(success: false)
                }
            }
        }
    }
    
    func showLogin() -> UIViewController {
        wireframe.showLogin(with:self)
    }
}
