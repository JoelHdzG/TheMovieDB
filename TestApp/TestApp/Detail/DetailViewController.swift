//
//  DetailViewController.swift
//  TestApp
//
//  Created by jehernandezg on 16/05/22.
//

import UIKit

protocol DetailViewOutput {
    func getDetail(onSuccess: @escaping (_ model: ShowDetail?) -> Void)
    func showTrailer()
    func getProducers() -> [Production_companies]?
}

final class DetailViewController: UIViewController {
    private lazy var scroll: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.sizeToFit()
        scroll.backgroundColor = .clear
        return scroll
    }()
    private lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.backgroundColor = .clear
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var movieView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .redraw
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "loader")
        return imageView
    }()
    private lazy var movieTitle: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        return label
    }()
    private lazy var movieDate: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        return label
    }()
    private lazy var overview: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    private lazy var homepage: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        return label
    }()
    private lazy var originalLanguage: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        return label
    }()
    private lazy var genre: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        return label
    }()
    private lazy var producersTitle: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        label.text = "Producers"
        label.textAlignment = .center
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3.3, height: 170)
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    private lazy var trailerButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(UIColor.AppColors.segmentedBackgroundColor, for: .normal)
        button.setTitle("Show Trailer", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapShowTrailer), for: .touchUpInside)
        return button
    }()

    let presenter: DetailViewOutput
    
    init(presenter: DetailViewOutput) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getDetail { [weak self] model in
            guard let self = self else { return }
            self.setup()
            self.navigationItem.title = model?.name ?? model?.original_title
            self.movieView.downloadImage(path: model?.backdrop_path ?? "")
            self.movieTitle.text = "Title: \(model?.name ?? model?.original_title ?? "")"
            self.movieDate.text = "Date: \(model?.first_air_date ?? model?.release_date ?? "")"
            self.overview.text = "Overview:\n\(model?.overview ?? "")"
            self.homepage.text = "Home page:\n\(model?.homepage ?? "")"
            self.originalLanguage.text = "Original Languaje: \(model?.original_language?.description.capitalized ?? "")"
            var genres = ""
            model?.genres?.forEach({ gen in
                genres = "\(genres), \(gen.name ?? "")"
            })
            genres = String(genres.suffix(genres.count-2))
            self.genre.text = "Genres: \(genres)"
        }
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.AppColors.homeCellBackgroundColor
        self.view.addSubview(scroll)
        scroll.addSubview(container)
        container.addSubview(stackView)
        
        stackView.addArrangedSubview(movieView)
        stackView.addArrangedSubview(movieTitle)
        stackView.addArrangedSubview(movieDate)
        stackView.addArrangedSubview(overview)
        stackView.addArrangedSubview(homepage)
        stackView.addArrangedSubview(originalLanguage)
        stackView.addArrangedSubview(genre)
        stackView.addArrangedSubview(producersTitle)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(trailerButton)
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let contentS = scroll.contentLayoutGuide
        
        container.topAnchor.constraint(equalTo: contentS.topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: contentS.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: contentS.trailingAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: contentS.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: contentS.widthAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor).isActive = true
        
        movieView.translatesAutoresizingMaskIntoConstraints = false
        movieView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        movieView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-16).isActive = true
        
        trailerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        collectionView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailProducersCell.self, forCellWithReuseIdentifier: "DetailProduccersCell")
        collectionView.reloadData()
    }
    
    @objc func didTapShowTrailer() {
        presenter.showTrailer()
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let source = presenter.getProducers() else { return 0 }
        self.collectionView.isHidden = source.count > 0 ? false : true
        self.producersTitle.isHidden = source.count > 0 ? false : true
        return source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailProduccersCell", for: indexPath) as! DetailProducersCell
        guard let source = presenter.getProducers() else { return cell }
        cell.model = source[indexPath.row]
        return cell
    }
}
