//
//  DetailWireframe.swift
//  TestApp
//
//  Created by jehernandezg on 16/05/22.
//

import UIKit
import AVKit
import AVFoundation

protocol DetailWireframeProtocol {
    func showDetail(with presenter: DetailViewOutput)
    func showAnimation(completion: @escaping () -> Void)
    func hideAnimation(completion: @escaping () -> Void)
    func showAlert(message: String)
    func showTrailer()
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
        DispatchQueue.main.async {
            self.baseController?.present(self.animationView ?? UIAlertController(), animated: true, completion: {
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
        let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in }))
        baseController?.present(alert, animated: true, completion: nil)
    }
    
    func showTrailer() {
        let videoURL = URL(string: "https://static.videezy.com/system/resources/previews/000/002/282/original/slow-motion-pouring-water.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        guard let navigation = baseController else { return }
        navigation.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
}
