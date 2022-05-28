//
//  ProfileWireframe.swift
//  TestApp
//
//  Created by jehernandezg on 17/05/22.
//

import UIKit

protocol ProfileWireframeProtocol {
    func showProfile(with presenter: ProfileViewOutput)
}

final class ProfileWireframe {

    private weak var baseController: UINavigationController?
    
    init(baseController: UINavigationController?) {
        self.baseController = baseController
    }
}

extension ProfileWireframe: ProfileWireframeProtocol {
    func showProfile(with presenter: ProfileViewOutput) {
        guard let baseController = baseController else { return }
        let viewController = ProfileViewController(presenter: presenter)
        baseController.present(viewController, animated: true, completion: nil)
    }
}
