//
//  MovieViewModel.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import Foundation

struct MovieViewModel {
    let coverImage: URL?
}

struct MovieCastViewModel {
    
    let cast: Cast
    
    init(cast: Cast) {
        self.cast = cast
    }
    
    
    var profileImage: URL? {
        if let posterPath = cast.profile_path {
            return URL(string: "https://image.tmdb.org/t/p/w500"+posterPath)
        }
        return URL(string: "")
    }
    
    var artisName: String {
        return cast.original_name
    }
}


