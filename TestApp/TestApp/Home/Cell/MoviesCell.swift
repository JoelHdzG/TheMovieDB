//
//  MoviesCell.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import UIKit

class MoviesCell: UICollectionViewCell {
    private let coverView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .redraw
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "loader")
        return imageView
    }()
    private let favoriteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        return button
    }()
    private let movieTitle: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        return label
    }()
    private let movieDate: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        return label
    }()
    private let movieRate: GreenLabel = {
        let label = GreenLabel(frame: .zero)
        return label
    }()
    private let movieDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.sizeToFit()
        label.textColor = .white
        label.numberOfLines = 4
        return label
    }()
    
    var model: Results? {
        didSet {
            movieTitle.text = model?.name ?? model?.original_title
            movieDate.text = model?.first_air_date ?? model?.release_date
            movieRate.text = "★ \(model?.vote_average ?? 0.0)"
            movieDescription.text = model?.overview
            coverView.downloadImage(path: model?.backdrop_path ?? "")
            let outLine: UIImage = UIImage(systemName: "star") ?? UIImage()
            let filled: UIImage = UIImage(systemName: "star.fill") ?? UIImage()
            favoriteButton.setImage(model?.isFavorite ?? false ? filled : outLine, for: .normal)
            favoriteButton.isHidden = comesFromFavorite
        }
    }
    var index: Int = 0
    var comesFromFavorite = false
    
    var presenter: HomeViewOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.coverView.image = UIImage(named: "loader")
    }
    
    func setup() {
        let radius = contentView.bounds.width / 13.0
        self.contentView.backgroundColor = UIColor.AppColors.homeCellBackgroundColor
        self.contentView.layer.cornerRadius = radius
        self.contentView.addSubview(coverView)
        self.contentView.addSubview(movieTitle)
        self.contentView.addSubview(movieDate)
        self.contentView.addSubview(movieRate)
        self.contentView.addSubview(favoriteButton)
        self.contentView.addSubview(movieDescription)
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        coverView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        coverView.layer.cornerRadius = radius
        coverView.layer.masksToBounds = true
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        favoriteButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.topAnchor.constraint(equalTo: coverView.bottomAnchor, constant: 8).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        movieDate.translatesAutoresizingMaskIntoConstraints = false
        movieDate.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 8).isActive = true
        movieDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        
        movieRate.translatesAutoresizingMaskIntoConstraints = false
        movieRate.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 8).isActive = true
        movieRate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        movieDescription.translatesAutoresizingMaskIntoConstraints = false
        movieDescription.topAnchor.constraint(equalTo: movieDate.bottomAnchor, constant: 12).isActive = true
        movieDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        movieDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        movieDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    @objc func didTapFavorite() {
        presenter?.saveFavorite(index: index)
    }
}
