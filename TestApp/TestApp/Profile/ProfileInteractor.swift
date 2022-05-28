//
//  ProfileInteractor.swift
//  TestApp
//
//  Created by jehernandezg on 17/05/22.
//

import Foundation

protocol ProfileInteractorProtocol {
    func getFavorites() -> [Results]?
}

final class ProfileInteractor {

}

extension ProfileInteractor: ProfileInteractorProtocol {
    func getFavorites() -> [Results]? {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([Results].self, from: data) {
                debugPrint(decoded)
                return decoded
            }
        }
        return nil
    }
    

}
