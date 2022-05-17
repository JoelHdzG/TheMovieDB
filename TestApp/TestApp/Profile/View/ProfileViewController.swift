//
//  ProfileViewController.swift
//  TestApp
//
//  Created by jehernandezg on 17/05/22.
//

import UIKit

protocol ProfileViewOutput {
    func showProfile()
}

final class ProfileViewController: UIViewController {
    private lazy var lblTitle: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        label.text = "Profile"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    private lazy var profileView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .redraw
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "user")
        return imageView
    }()
    private lazy var lblMail: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        label.text = "joelhernandezg77@gmail.com"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    let presenter: ProfileViewOutput
    
    init(presenter: ProfileViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil,
                   bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.hidesBackButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        setup()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.AppColors.homeCellBackgroundColor
        self.view.layer.cornerRadius = 15
        self.view.addSubview(lblTitle)
        self.view.addSubview(profileView)
        self.view.addSubview(lblMail)
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 16).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileView.layer.cornerRadius = 75
        profileView.clipsToBounds = true
        profileView.layer.masksToBounds = true
        
        lblMail.translatesAutoresizingMaskIntoConstraints = false
        lblMail.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 2).isActive = true
        lblMail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        lblMail.centerYAnchor.constraint(equalTo: profileView.centerYAnchor).isActive = true
    }
}
