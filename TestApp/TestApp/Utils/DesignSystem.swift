//
//  DesignSystem.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import UIKit
import Foundation

extension UIColor {
    struct AppColors {
        static var navigationColor: UIColor { return UIColor(red: 0.16, green: 0.20, blue: 0.22, alpha: 1.00) }
        static var homeCellBackgroundColor: UIColor { return UIColor(red: 0.03, green: 0.13, blue: 0.16, alpha: 1.00) }
        static var homeBackgroundColor: UIColor { return UIColor(red: 0.03, green: 0.06, blue: 0.07, alpha: 1.00) }
        static var labelGreen: UIColor { return UIColor(red: 0.00, green: 0.71, blue: 0.38, alpha: 1.00) }
        static var segmentedBackgroundColor: UIColor { return UIColor(red: 0.05, green: 0.10, blue: 0.13, alpha: 1.00) }
    }
}

extension UIAlertController {
    struct GlobalViews {
        static var animationView: UIAlertController {
            return UIAlertController(title: "Espere por favor...", message: nil, preferredStyle: .alert)
        }
        static func warningAlert(_ message: String) -> UIAlertController {
            let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in }))
            return alert
        }
    }
}


extension UIImageView {
    func downloadImage(path: String) {
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")!
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
    }
}
