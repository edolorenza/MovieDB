//
//  TitleHeaderSearchCollectionViewCell.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import UIKit

class TitleHeaderSearchCollectionViewCell: UICollectionReusableView {
    //MARK: - Properties
    static let identifier = "TitleHeaderSearchCollectionViewCell"
    
    private let titleSectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.text = "showing result of"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let queryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Helpers
    func configure(with title: String) {
        queryLabel.text = "'\(title)'"
    }
    
    private func setupView(){
        addSubview(titleSectionLabel)
        titleSectionLabel.centerY(inView: self)
        titleSectionLabel.anchor(left: leftAnchor, paddingLeft: 8)
        
        addSubview(queryLabel)
        queryLabel.centerY(inView: self)
        queryLabel.anchor(left: titleSectionLabel.rightAnchor, paddingLeft: 4)
    }
}
