//
//  HomeMoviesCell.swift
//  TestApp
//
//  Created by jehernandezg on 14/05/22.
//

import UIKit

class HomeMoviesCell: UICollectionViewCell {
    private let coverView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .redraw
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "loader")
        return imageView
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
        }
    }
    
    var presenter: HomeViewOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView.backgroundColor = UIColor.AppColors.homeCellBackgroundColor
        self.contentView.layer.cornerRadius = 15
        self.contentView.addSubview(coverView)
        self.contentView.addSubview(movieTitle)
        self.contentView.addSubview(movieDate)
        self.contentView.addSubview(movieRate)
        self.contentView.addSubview(movieDescription)
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        coverView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        coverView.layer.cornerRadius = 15
        
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
}
