//
//  LoginInteractor.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import Foundation

protocol LoginInteractorProtocol {
    func fetchLogin(user: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void)
}

final class LoginInteractor: LoginInteractorProtocol {
    func fetchLogin(user: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if user == "Joel" && password == "Security135" {
                onSuccess()
            } else {
                onError()
            }
        }
    }
}
