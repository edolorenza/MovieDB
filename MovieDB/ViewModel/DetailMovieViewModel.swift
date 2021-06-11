//
//  DetailMovieViewModel.swift
//  MovieDB
//
//  Created by Edo Lorenza on 11/06/21.
//

import Foundation

struct DetailMovieViewModel {
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var movieTitle: String {
        return movie.title
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
      let Hours = (seconds % 3600) / 60
      let minutes = (seconds % 3600) % 60
      let runtime = "\(Hours)h, \(minutes)m"
      return runtime
    }
    
    var runtime: String {
        return secondsToHoursMinutesSeconds(seconds: movie.id)
    }
    
    var genre: String {
        let genre: [String] = movie.genres?.compactMap({
                  $0.name
              }) ?? [""]
        
        return genre.joined(separator: ", ")
    }
    
    var summary: String {
        return movie.overview
    }
    
    var coverImage: URL? {
        if let posterPath = movie.poster_path {
            return URL(string: "https://image.tmdb.org/t/p/w500"+posterPath)
        }
        return URL(string: "")
    }
    
}

