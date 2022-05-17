//
//  DetailWireframe.swift
//  TestApp
//
//  Created by jehernandezg on 16/05/22.
//

import UIKit

protocol DetailWireframeProtocol {
    func showDetail(with presenter: DetailViewOutput)
    func showAnimation(completion: @escaping () -> Void)
    func hideAnimation(completion: @escaping () -> Void)
    func showAlert(message: String)
}

final class DetailWireframe {
    private weak var baseController: UINavigationController?
    private var animationView: UIAlertController?
    
    init(baseController: UINavigationController?) {
        self.baseController = baseController
    }
}

extension DetailWireframe: DetailWireframeProtocol {
    func showDetail(with presenter: DetailViewOutput) {
        guard let navigation = baseController else { return }
        let viewController = DetailViewController(presenter: presenter)
        navigation.pushViewController(viewController, animated: true)
    }
    
    func showAnimation(completion: @escaping () -> Void) {
        animationView = UIAlertController.GlobalViews.animationView
        baseController?.present(animationView ?? UIAlertController(), animated: true, completion: {
            completion()
        })
    }
    
    func hideAnimation(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.animationView?.dismiss(animated: true, completion: {
                completion()
            })
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in }))
        baseController?.present(alert, animated: true, completion: nil)
    }
    
}
