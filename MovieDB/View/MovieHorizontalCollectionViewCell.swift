//
//  MovieHorizontalCollectionViewCell.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import UIKit
import SDWebImage

class MovieHorizontalCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "MovieHorizontalCollectionViewCell"
    
    //MARK: - Properties
    private let coverImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    //MARK: - lifecycle
    override init (frame: CGRect){
    super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) Has Not Been Implemented")
    }
    
    //MARK: - Helpers
    func setupView(){
        addSubview(coverImageView)
    
        coverImageView.anchor(top: self.safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        coverImageView.setDimensions(height: frame.height, width: frame.width)
        coverImageView.dropShadow()
    }
    
    func configure(with viewModel: MovieViewModel){
        coverImageView.sd_setImage(with: viewModel.coverImage)
    }
}


