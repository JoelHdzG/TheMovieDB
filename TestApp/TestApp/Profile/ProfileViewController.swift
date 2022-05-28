//
//  ProfileViewController.swift
//  TestApp
//
//  Created by jehernandezg on 17/05/22.
//

import UIKit

protocol ProfileViewOutput {
    func showProfile()
    var dataSource: [Results]? { get }
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private lazy var lblFavorites: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        label.text = "Favorites"
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-45)/2, height: 320)
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
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
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCollectionView()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.AppColors.homeBackgroundColor
        self.view.layer.cornerRadius = 15
        self.view.addSubview(lblTitle)
        self.view.addSubview(profileView)
        self.view.addSubview(lblMail)
        self.view.addSubview(lblFavorites)
        self.view.addSubview(collectionView)
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 16).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        profileView.layer.cornerRadius = 65
        profileView.clipsToBounds = true
        profileView.layer.masksToBounds = true
        
        lblMail.translatesAutoresizingMaskIntoConstraints = false
        lblMail.leadingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: 6).isActive = true
        lblMail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        lblMail.centerYAnchor.constraint(equalTo: profileView.centerYAnchor).isActive = true
        
        lblFavorites.translatesAutoresizingMaskIntoConstraints = false
        lblFavorites.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        lblFavorites.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        lblFavorites.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 16).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: lblFavorites.bottomAnchor, constant: 16).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 320).isActive = true
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: "MoviesCell")
        collectionView.reloadData()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let source = presenter.dataSource else {
            self.collectionView.isHidden = true
            self.lblFavorites.isHidden = true
            return 0
        }
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
        guard let source = presenter.dataSource else { return cell }
        cell.comesFromFavorite = true
        cell.model = source[indexPath.row]
        return cell
    }
}
