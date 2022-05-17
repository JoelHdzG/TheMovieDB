//
//  LoginViewController.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import UIKit

protocol LoginViewOutput {
    var delegate: LoginViewDelegate? { get set }
    func setLogin(user: String?, password: String?)
    func showHome()
}

protocol LoginViewDelegate: AnyObject{
    func willShowLoginError(success: Bool)
}

final class LoginViewController: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    private lazy var userTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = " Ingresa tu usuario"
        textField.backgroundColor = .white
        return textField
    }()
    private lazy var securityTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = " Ingresa tu contraseña"
        textField.backgroundColor = .white
        return textField
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()
    private lazy var errorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemOrange
        label.text = "Usuario y/o contraseña incorrectos, intenta nuevamente."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    var presenter: LoginViewOutput
    
    init(presenter: LoginViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil,
                   bundle:nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setup() {
        presenter.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(userTextField)
        self.view.addSubview(securityTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(errorLabel)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/3.5).isActive = true
        userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        userTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userTextField.layer.cornerRadius = 5
        
        securityTextField.translatesAutoresizingMaskIntoConstraints = false
        securityTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 25).isActive = true
        securityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        securityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        securityTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        securityTextField.layer.cornerRadius = 5
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: securityTextField.bottomAnchor, constant: 25).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.layer.cornerRadius = 5
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func didTapLogin() {
        presenter.setLogin(user: userTextField.text, password: securityTextField.text)
    }
}

extension LoginViewController: LoginViewDelegate {
    func willShowLoginError(success: Bool) {
        errorLabel.isHidden = success
    }
}
