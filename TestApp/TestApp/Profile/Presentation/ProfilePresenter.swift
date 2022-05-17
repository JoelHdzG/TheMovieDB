//
//  ProfilePresenter.swift
//  TestApp
//
//  Created by jehernandezg on 17/05/22.
//

import Foundation

protocol ProfilePresenterProtocol: ProfileViewOutput {
    func showProfile()
}

final class ProfilePresenter {
    private let wireframe: ProfileWireframeProtocol
    private let interactor: ProfileInteractorProtocol
    
    init(wireframe: ProfileWireframeProtocol, interactor: ProfileInteractorProtocol) {
        self.wireframe = wireframe
        self.interactor = interactor
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func showProfile() {
        wireframe.showProfile(with:self)
    }
}
