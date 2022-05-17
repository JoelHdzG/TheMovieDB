//
//  HomeViewController.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import UIKit

protocol HomeViewOutput {
    func showNavigationActionSheet()
    func fetchList(section: showType, onSuccess: @escaping (_ model: [Results]?) -> Void)
    func showDetail(itemId: Int, detailType: detailType)
}

final class HomeViewController: UIViewController {
    private lazy var navigationTitle: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitle("TVShows", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapNavigationTitle), for: .touchUpInside)
        return button
    }()
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Popular","Top Rated","On TV","Airing Today"]
        let segmented = UISegmentedControl(items: items)
        segmented.selectedSegmentTintColor = .white
        segmented.tintColor = .gray
        segmented.backgroundColor = UIColor.AppColors.segmentedBackgroundColor
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(selectSection(_:)), for: .valueChanged)
        return segmented
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2.3, height: UIScreen.main.bounds.height/2.5)
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private var dataSource = [Results]()
    let presenter: HomeViewOutput
    
    init(presenter: HomeViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil,
                   bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectSection(segmentedControl)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeMoviesCell.self, forCellWithReuseIdentifier: "HomeMoviesCell")
        collectionView.reloadData()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.AppColors.homeBackgroundColor
        self.navigationItem.titleView = navigationTitle
        self.view.addSubview(segmentedControl)
        self.view.addSubview(collectionView)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func didTapNavigationTitle() {
        presenter.showNavigationActionSheet()
    }
    
    @objc func selectSection(_ sender: UISegmentedControl) {
        var selection: showType!
        switch sender.selectedSegmentIndex {
        case 0:
            selection = .popular
            break
        case 1:
            selection = .topRated
            break
        case 2:
            selection = .onTv
            break
        case 3:
            selection = .airingToday
            break
        default:
            break
        }
        presenter.fetchList(section: selection) { [weak self] data in
            guard let self = self else { return }
            if let model = data {
                self.dataSource = model
                self.collectionView.reloadData()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMoviesCell", for: indexPath) as! HomeMoviesCell
        cell.presenter = presenter
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = segmentedControl.selectedSegmentIndex == 0 || segmentedControl.selectedSegmentIndex == 1 ? detailType.movieDetail : detailType.TVDetail
        presenter.showDetail(itemId: dataSource[indexPath.row].id ?? 0, detailType: detail)
    }
}
