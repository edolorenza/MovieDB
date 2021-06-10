//
//  LibraryViewController.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import UIKit

class LibraryViewController: UIViewController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    //MARK: - Helpers
    private func setupView(){
        view.backgroundColor = .systemBackground
    }
}
