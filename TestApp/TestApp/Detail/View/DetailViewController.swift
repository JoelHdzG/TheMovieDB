//
//  DetailViewController.swift
//  TestApp
//
//  Created by jehernandezg on 16/05/22.
//

import UIKit

protocol DetailViewOutput {
    func getDetail(onSuccess: @escaping (_ model: ShowDetail?) -> Void)
}

final class DetailViewController: UIViewController {
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
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getDetail { [weak self] model in
            guard let self = self else { return }
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
        self.view.layer.cornerRadius = 15
        self.view.addSubview(movieView)
        self.view.addSubview(movieTitle)
        self.view.addSubview(movieDate)
        self.view.addSubview(overview)
        self.view.addSubview(homepage)
        self.view.addSubview(originalLanguage)
        self.view.addSubview(genre)
        
        movieView.translatesAutoresizingMaskIntoConstraints = false
        movieView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        movieView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        movieView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        movieView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        movieView.layer.cornerRadius = 15
        
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.topAnchor.constraint(equalTo: movieView.bottomAnchor, constant: 16).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        movieDate.translatesAutoresizingMaskIntoConstraints = false
        movieDate.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 16).isActive = true
        movieDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        movieDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        overview.translatesAutoresizingMaskIntoConstraints = false
        overview.topAnchor.constraint(equalTo: movieDate.bottomAnchor, constant: 16).isActive = true
        overview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        overview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true

        homepage.translatesAutoresizingMaskIntoConstraints = false
        homepage.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 16).isActive = true
        homepage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        homepage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        originalLanguage.translatesAutoresizingMaskIntoConstraints = false
        originalLanguage.topAnchor.constraint(equalTo: homepage.bottomAnchor, constant: 16).isActive = true
        originalLanguage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        originalLanguage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        genre.translatesAutoresizingMaskIntoConstraints = false
        genre.topAnchor.constraint(equalTo: originalLanguage.bottomAnchor, constant: 16).isActive = true
        genre.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        genre.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }
}
