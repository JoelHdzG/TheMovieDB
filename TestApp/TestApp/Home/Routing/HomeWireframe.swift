//
//  HomeWireframe.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import UIKit

protocol HomeWireframeProtocol {
    func showHome(with presenter: HomeViewOutput)
    func showNavigationActionSheet()
    func showAnimation(completion: @escaping () -> Void)
    func hideAnimation(completion: @escaping () -> Void)
    func showAlert(message: String)
    func showDetailModule(itemId: Int, detailType: detailType)
    func showProfeileModule()
}

final class HomeWireframe {

    private weak var baseController: UINavigationController?
    private var animationView: UIAlertController?
    
    init(baseController: UINavigationController?) {
        self.baseController = baseController
    }
}

extension HomeWireframe: HomeWireframeProtocol {
    func showNavigationActionSheet() {
        guard let navigation = baseController else { return }
        let actionSheet = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "View Profile", style: .default, handler: { action in
            let module = ProfileModule(with: navigation)
            module.showProfile()
        }))
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { action in
            navigation.popToRootViewController(animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        navigation.present(actionSheet, animated: true)
    }
    
    func showHome(with presenter: HomeViewOutput) {
        guard let navigation = baseController else { return }
        let viewController = HomeViewController(presenter: presenter)
        navigation.pushViewController(viewController, animated: true)
    }
    
    func showAnimation(completion: @escaping () -> Void) {
        animationView = UIAlertController.GlobalViews.animationView
        baseController?.present(animationView ?? UIAlertController(), animated: true, completion: {
            completion()
        })
    }
    
    func hideAnimation(completion: @escaping () -> Void) {
        animationView?.dismiss(animated: true, completion: {
            completion()
        })
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in }))
        baseController?.present(alert, animated: true, completion: nil)
    }
    
    func showDetailModule(itemId: Int, detailType: detailType) {
        let module = DetailModule(with: baseController ?? UINavigationController(), detailType: detailType, itemId: itemId)
        module.showDetail()
    }
    
    func showProfeileModule() {
        let module = ProfileModule(with: baseController ?? UINavigationController())
        module.showProfile()
    }
}
