//
//  HomeViewController.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import UIKit

protocol HomeViewOutput {
    var delegate: HomeViewDelegate? { get set }
    func showNavigationActionSheet()
    func fetchList(section: showType, onSuccess: @escaping () -> Void)
    var dataSource: [Results]? { get }
    func showDetail(itemId: Int, detailType: detailType)
    func saveFavorite(index: Int)
}

protocol HomeViewDelegate: AnyObject {
    func updateData()
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
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-45)/2, height: UIScreen.main.bounds.height/2.5)
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    var presenter: HomeViewOutput
    
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
        if let flow = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.itemSize = CGSize(width: (self.collectionView.frame.size.width-20)/2, height: self.collectionView.frame.size.height/2.3)
        }
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
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: "MoviesCell")
        collectionView.reloadData()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.AppColors.homeBackgroundColor
        self.navigationItem.titleView = navigationTitle
        self.view.addSubview(segmentedControl)
        self.view.addSubview(collectionView)
        self.presenter.delegate = self
        
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
        presenter.fetchList(section: selection) {
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.presenter = presenter
        guard let source = presenter.dataSource else { return cell }
        cell.model = source[indexPath.row]
        cell.index = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = segmentedControl.selectedSegmentIndex == 0 || segmentedControl.selectedSegmentIndex == 1 ? detailType.movieDetail : detailType.TVDetail
        guard let source = presenter.dataSource else { return }
        presenter.showDetail(itemId: source[indexPath.row].id ?? 0, detailType: detail)
    }
}

extension HomeViewController: HomeViewDelegate {
    func updateData() {
        self.collectionView.reloadData()
    }
}
