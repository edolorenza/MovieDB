//
//  DetailMovieViewController.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import UIKit
import SDWebImage

class DetailMovieViewController: UIViewController{
    //MARK: - Properties
    
    private var movie: Movie
    
    private let coverImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    lazy var watchTrailerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        let icon = UIImage(systemName: "play")
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.layer.cornerRadius = 4
        button.setTitle("Watch Trailer", for: .normal)
        button.tintColor = .black
        button.layer.masksToBounds = true
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(didTapWatchLater), for: .touchUpInside)
        return button
    }()
    
    lazy var addToFavoriteButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        let icon = UIImage(systemName: "plus")
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.layer.cornerRadius = 4
        button.setTitle("Add to Favorite", for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddToFavorite), for: .touchUpInside)
        return button
    }()
    
    private let overlay: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = .black
        overlay.alpha = 0.5
        return overlay
    }()

    let scrollView: UIScrollView = {
       let v = UIScrollView()
       v.translatesAutoresizingMaskIntoConstraints = false
       v.contentInsetAdjustmentBehavior = .never
       return v
    }()

    private let summary: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.view.backgroundColor = UIColor.clear
        prepareForReuse()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let loader = self.loader()
        self.fetchData()
        DispatchQueue.main.async {
            self.stopLoader(loader: loader)
        }
       
    }
     func prepareForReuse() {
        titleLabel.text = nil
        summary.text = nil
        coverImage.image = nil
        genreLabel.attributedText = nil
        runtimeLabel.text = nil
        watchTrailerButton.isHidden = true
        addToFavoriteButton.isHidden = true
        overlay.isHidden = true
     }
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(scrollView)
    }
    
    //MARK: - Actions
    @objc func didTapWatchLater(){
        alert()
    }
    
    @objc func didTapAddToFavorite(){
        alert()
    }
    
    //MARK: - API
    private func fetchData(){
        APICaller.shared.getMovieDetail(movie: movie) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.movie = model
                    self?.configure()
                case . failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    //MARK: - Helpers
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
          // constrain the scroll view
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        
        scrollView.addSubview(coverImage)
        let coverImageHeight = view.frame.height/2
        coverImage.anchor(top: scrollView.topAnchor,left: view.leftAnchor,right: view.rightAnchor, height: coverImageHeight)
        
        scrollView.addSubview(overlay)
        overlay.anchor(left: view.leftAnchor, bottom: coverImage.bottomAnchor)
        overlay.setDimensions(height: coverImageHeight/4, width: view.frame.width)
        
        let headerStack = UIStackView(arrangedSubviews: [titleLabel, runtimeLabel, genreLabel])
        headerStack.distribution = .fillEqually
        
        scrollView.addSubview(headerStack)
        headerStack.axis = .vertical
        headerStack.spacing = 2
        
        headerStack.anchor(top: coverImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: -(coverImageHeight/5), paddingLeft: 16, paddingRight: 16)
        runtimeLabel.setHeight(28)
        titleLabel.setHeight(28)
        
        scrollView.addSubview(watchTrailerButton)
        watchTrailerButton.anchor(top: coverImage.bottomAnchor, left: view.leftAnchor, paddingLeft: 16)
        watchTrailerButton.setDimensions(height: 50, width: (view.frame.width/2) - 24 )
        
        scrollView.addSubview(addToFavoriteButton)
        addToFavoriteButton.anchor(top: coverImage.bottomAnchor, left: watchTrailerButton.rightAnchor,right: view.rightAnchor, paddingLeft: 8, paddingRight: 16)
        addToFavoriteButton.setHeight(50)
        
        watchTrailerButton.setHeight(50)
        addToFavoriteButton.setHeight(50)
        watchTrailerButton.dropShadow()
        addToFavoriteButton.dropShadow()
        addToFavoriteButton.layer.borderWidth = 0.5
        
        scrollView.addSubview(summary)
        summary.anchor(top: watchTrailerButton.bottomAnchor, left: view.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16)
        
    }
    
    func configure(){
        
        let genre: [String] = movie.genres?.compactMap({
            $0.name
        }) ?? [""]
        
        if let backdrop = movie.poster_path {
            coverImage.sd_setImage(with: URL(string:"https://image.tmdb.org/t/p/w500"+backdrop))
        }
        guard let second = movie.runtime else { return }
        let runtime = secondsToHoursMinutesSeconds(seconds: second)
        summary.text = movie.overview
        titleLabel.text = movie.original_title
        runtimeLabel.text = "\(runtime)"
        genreLabel.text = genre.joined(separator: ", ")
        
        watchTrailerButton.isHidden = false
        addToFavoriteButton.isHidden = false
        overlay.isHidden = false
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
      let Hours = (seconds % 3600) / 60
      let minutes = (seconds % 3600) % 60
      let runtime = "\(Hours)h, \(minutes)m"
      return runtime
    }

    
    func atributedText(title: String, Value: String) -> NSAttributedString {
        let atributedString = NSMutableAttributedString(string: "\(title)\n", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.secondaryLabel])
        atributedString.append(NSAttributedString(string: Value, attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.label]))
        return atributedString
    }
    
    private func alert(){
        let alert = UIAlertController(title: "Oops",
                                      message: "coming soon feature",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}
 
extension DetailMovieViewController{
    func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "please wait..", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.startAnimating()
        alert.view.addSubview(indicator)
        self.present(alert, animated: true, completion: nil)
        return alert
    }
    
    func stopLoader(loader: UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}

