//
//  LoginWireframe.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import UIKit

protocol LoginWireframeProtocol {
    var navigation: UINavigationController? { get set }
    func showLogin(with presenter: LoginViewOutput) -> UIViewController
    func showAlert(message: String)
    func showAnimation(completion: @escaping () -> Void)
    func hideAnimation(completion: @escaping () -> Void)
    func showHomeModule()
}

protocol LoginPresenterToViewDelegate: AnyObject {
    func willShowCredentialsErro(success: Bool)
}
final class LoginWireframe {
    weak var navigation: UINavigationController?
    private var animationView: UIAlertController?
}

extension LoginWireframe: LoginWireframeProtocol {
    func showHomeModule() {
        let module = HomeModule(with: navigation ?? UINavigationController())
        module.showHome()
    }
    
    func showAnimation(completion: @escaping () -> Void) {
        animationView = UIAlertController.GlobalViews.animationView
        DispatchQueue.main.async {
            self.navigation?.present(self.animationView ?? UIAlertController(), animated: true, completion: {
                completion()
            })
        }
    }
    
    func hideAnimation(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.animationView?.dismiss(animated: true, completion: {
                completion()
            })
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController.GlobalViews.warningAlert(message)
        navigation?.present(alert, animated: true, completion: nil)
    }
    
    func showLogin(with presenter: LoginViewOutput) -> UIViewController {
        return LoginViewController(presenter: presenter)
    }
}
