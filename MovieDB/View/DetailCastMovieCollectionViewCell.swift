//
//  DetailCastMovieCollectionViewCell.swift
//  MovieDB
//
//  Created by Edo Lorenza on 11/06/21.
//

import UIKit
import SDWebImage

class DetailCastMovieCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    
    var viewModel: MovieCastViewModel? {
        didSet { configure() }
    }
    
    static let identifier = "DetailCastMovieCollectionViewCell"
    
    private let profileImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    

    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForReuse()
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
        profileImage.image = nil
        artistNameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
    
    
    //MARK: - Actions
  
    
    //MARK: - Helpers
    func configure() {
        profileImage.sd_setImage(with: viewModel?.profileImage)
        artistNameLabel.text = viewModel?.artisName
    }
    
    private func setupView(){
        contentView.addSubview(profileImage)
        profileImage.setDimensions(height: frame.width, width: frame.width)
        profileImage.layer.cornerRadius = frame.width/2
        
        contentView.addSubview(artistNameLabel)
        artistNameLabel.anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8)
    }

}
