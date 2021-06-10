//
//  UpcomingMovieCollectionViewCell.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import UIKit
import SDWebImage

class UpcomingMovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "UpcomingMovieCollectionViewCell"
    
    var viewModel: UpcomingMovieViewModel? {
        didSet { configure() }
    }
    

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        return label
    }()
    


    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Helpers
    private func setupView(){
        contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 4
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
        imageView.setHeight(frame.height-40)
        
        contentView.addSubview(genreLabel)
        genreLabel.backgroundColor = .systemYellow
        genreLabel.layer.cornerRadius = 4
        genreLabel.anchor(top: imageView.bottomAnchor, left: imageView.leftAnchor, paddingTop: -30, paddingLeft: 8)
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8)
    }
    
    

    func configure() {
        imageView.sd_setImage(with: viewModel?.coverImage)
        titleLabel.text = viewModel?.movieTitle
        genreLabel.text = viewModel?.genres.joined(separator: ", ")
    }
}

