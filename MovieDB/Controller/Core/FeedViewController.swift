//
//  FeedViewController.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import UIKit

enum FeedSectionType{
    case listNowPlayingMovie(viewModels: [MovieViewModel]) // 0
    case listPopularMovie(viewModels: [MovieViewModel]) //1
    case listTopRatedMovie(viewModels: [MovieViewModel]) //1
    
    var title: String{
        switch self {
        case .listNowPlayingMovie:
            return "Now Playing"
        case .listPopularMovie:
            return "Popular"
        case .listTopRatedMovie:
            return "Top Rated"
        }
    }
}


class FeedViewController: UIViewController {
    //MARK: - Properties
    private var playingMovie: [Movie] = []
    private var popularMovie: [Movie] = []
    private var TopRatedMovie: [Movie] = []
    
    let movieDBLogo = UIImageView(image: UIImage(named: "logo"))
    let titleView = UIView()
    
    lazy var notificationButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .label
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapNotification), for: .touchUpInside)
        return button
    }()
    
    
    private var collectionView: UICollectionView = UICollectionView (
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout {
            sectionIndex, _ -> NSCollectionLayoutSection? in
            return FeedViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private var sections = [FeedSectionType]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupNavBar()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        showNavBar()
    }
 
    //MARK: - Actions
    @objc func didTapNotification(){
        print("DEBUG: did tap notification button")
    }
    
    //MARK: - API
    private func fetchData() {
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var listNowPlayingMovie: MovieResponse?
        var listPopularMovie: MovieResponse?
        var lisTopRatedMovie: MovieResponse?
        
        //list of now playing movie
        APICaller.shared.getListOfFeed(with: APICaller.serviceUrlPath.now_playing) { result in
            defer {
                group.leave()
            }
            switch result {
                case.success(let model):
                    listNowPlayingMovie = model
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        //list of top rated movie
        APICaller.shared.getListOfFeed(with: APICaller.serviceUrlPath.popular) { result in
            defer {
                group.leave()
            }
            switch result {
                case.success(let model):
                    listPopularMovie = model
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        //list of top rated movie
        APICaller.shared.getListOfFeed(with: APICaller.serviceUrlPath.top_rated) { result in
            defer {
                group.leave()
            }
            switch result {
                case.success(let model):
                    lisTopRatedMovie = model
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
 
 
        
        group.notify(queue: .main){
            
            guard let nowPlaying = listNowPlayingMovie?.results,
                  let popular = listPopularMovie?.results,
                  let topRated = lisTopRatedMovie?.results
              
            else { return }
            
            self.configureModels(nowPlaying: nowPlaying, popular: popular, topRated: topRated)
        }
        
    }
    
    //MARK: - Helpers
    private func setupView(){
        configureCollectionView()
        fetchData()
    }
    
    private func setupNavBar(){
        let widht = view.frame.width
        titleView.addSubview(movieDBLogo)
        movieDBLogo.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        titleView.addSubview(notificationButton)
        notificationButton.frame = CGRect(x: widht-60, y: 0, width: 40, height: 40)
        titleView.frame = .init(x: 0, y: 0, width: widht, height: 100)
        navigationItem.titleView = titleView
    }
    
    private func showNavBar(){
        navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaTop = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
        let scrollAreaTOp: CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        
        let offset = scrollView.contentOffset.y + scrollAreaTOp
        let alpha: CGFloat = 1 - ((scrollView.contentOffset.y+scrollAreaTOp) / scrollAreaTOp)
    
        movieDBLogo.alpha = alpha
        notificationButton.alpha = alpha
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        //configure collectionview cell
        collectionView.register(NowPlayingMovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: NowPlayingMovieCollectionViewCell.identifier)
        collectionView.register(MovieHorizontalCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieHorizontalCollectionViewCell.identifier)
        collectionView.register(MovieHorizontalCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieHorizontalCollectionViewCell.identifier)
        
        //configure collectionView Header
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)

    
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func configureModels(nowPlaying: [Movie], popular: [Movie], topRated: [Movie]) {
        //configure models
        self.playingMovie = nowPlaying
        self.popularMovie = popular
        self.TopRatedMovie = topRated
        
      
        sections.append(.listNowPlayingMovie(viewModels: nowPlaying.compactMap({
            if let backdrop = $0.backdrop_path {
                return MovieViewModel(coverImage: URL(string: "https://image.tmdb.org/t/p/w500"+backdrop))
            }
            return MovieViewModel(coverImage: URL(string: ""))
        })))
        

        sections.append(.listPopularMovie(viewModels: popularMovie.compactMap({
            if let backdrop = $0.poster_path {
                return MovieViewModel(coverImage: URL(string: "https://image.tmdb.org/t/p/w300"+backdrop))
            }
            return MovieViewModel(coverImage: URL(string: ""))
        })))
    
        sections.append(.listTopRatedMovie(viewModels: TopRatedMovie.compactMap({
            if let backdrop = $0.poster_path {
                return MovieViewModel(coverImage: URL(string: "https://image.tmdb.org/t/p/w300"+backdrop))
            }
            return MovieViewModel(coverImage: URL(string: ""))
        })))
    
        
        collectionView.reloadData()
    }
    
  
}

//MARK: - UICollectionViewDelegate
extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .listNowPlayingMovie:
            let movie = playingMovie[indexPath.row]
            let vc = DetailMovieViewController(movie: movie)
            navigationController?.pushViewController(vc, animated: true)

        case .listPopularMovie:
            let movie = popularMovie[indexPath.row]
            let vc = DetailMovieViewController(movie: movie)
            navigationController?.pushViewController(vc, animated: true)
            
        case .listTopRatedMovie:
            let movie = TopRatedMovie[indexPath.row]
            let vc = DetailMovieViewController(movie: movie)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let model = sections[section].title
        header.configure(with: model)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .listNowPlayingMovie(let viewModels):
            return viewModels.count
        case .listPopularMovie(let viewModels):
            return viewModels.count
        case .listTopRatedMovie(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type {
        case .listNowPlayingMovie(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingMovieCollectionViewCell.identifier, for: indexPath) as? NowPlayingMovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .listPopularMovie(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieHorizontalCollectionViewCell.identifier, for: indexPath) as? MovieHorizontalCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .listTopRatedMovie(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieHorizontalCollectionViewCell.identifier, for: indexPath) as? MovieHorizontalCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
}

//MARK: - UICollectionViewCompositionalLayout
extension FeedViewController {
     static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        let supplementaryViews = [
         NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        ]
        
        switch section {
        case 0:
            // item
            let item = NSCollectionLayoutItem(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .fractionalHeight(1.0)))
      
            //group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                                  layoutSize: NSCollectionLayoutSize(
                                    widthDimension: .fractionalWidth(1.0),
                                  heightDimension: .absolute(300)),
                                  subitem: item, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case 1:
            // item
            let item = NSCollectionLayoutItem(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 0)
      
            //group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                                  layoutSize: NSCollectionLayoutSize(
                                  widthDimension: .fractionalWidth(0.30),
                                  heightDimension: .absolute(200)),
                                  subitem: item, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 2:
            // item
            let item = NSCollectionLayoutItem(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 0)
      
            //group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                                  layoutSize: NSCollectionLayoutSize(
                                  widthDimension: .fractionalWidth(0.30),
                                  heightDimension: .absolute(200)),
                                  subitem: item, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            // item
            let item = NSCollectionLayoutItem(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1.0),
                                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
            
            //group
            let group = NSCollectionLayoutGroup.vertical(
                                layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(0.9),
                                heightDimension: .absolute(390)),
                                subitem: item, count: 1)
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }
}

