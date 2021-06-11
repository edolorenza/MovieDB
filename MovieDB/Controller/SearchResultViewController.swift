//
//  SearchResultViewController.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func showResult(controller: UIViewController)
}

class SearchResultViewController: UIViewController {
    //MARK: - Properties
    private var movie: [Movie] = []
    
    var query: String?
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let supplementaryViews = [
             NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            ]
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 6,
                bottom: 2,
                trailing: 6
            )

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(300)),
                subitem: item,
                count: 2
            )

            group.contentInsets = NSDirectionalEdgeInsets(
                top: 4,
                leading: 0,
                bottom: 4,
                trailing: 0
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        })
    )
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
    }
    private func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UpcomingMovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: UpcomingMovieCollectionViewCell.identifier)
        
        //configure collectionView Header
        collectionView.register(TitleHeaderSearchCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderSearchCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.frame = view.bounds
        
    }
    
    //MARK: - Helpers
    func update(with results: [Movie]){
        self.movie = results
        collectionView.reloadData()
        collectionView.isHidden = results.isEmpty
    }
}


//MARK: - UICollectionViewDataSource
extension SearchResultViewController: UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderSearchCollectionViewCell.identifier, for: indexPath) as? TitleHeaderSearchCollectionViewCell, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
       
        if let query = query {
            let model = query
            header.configure(with: model)
        }
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMovieCollectionViewCell.identifier, for: indexPath) as? UpcomingMovieCollectionViewCell else  {
            return UpcomingMovieCollectionViewCell()
        }
        let movie = movie[indexPath.row]
        cell.viewModel = UpcomingMovieViewModel(movie: movie)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movie[indexPath.row]
        let vc = DetailMovieViewController(movie: movie)
        delegate?.showResult(controller: vc)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height = view.frame.height/2
        return CGSize(width: width, height: height)
    }
}
