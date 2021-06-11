//
//  UpcomingMovieViewModel.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import Foundation



struct UpcomingMovieViewModel {
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var movieTitle: String {
        return movie.title
    }
    
    var coverImage: URL? {
        if let posterPath = movie.poster_path {
            return URL(string: "https://image.tmdb.org/t/p/w500"+posterPath)
        }
        return URL(string: "")
    }
    
    var genres: [String] {
        return convertIntToString(with: movie)
    }
    
    func convertIntToString(with genre: Movie) -> [String] {
        guard let numbers = genre.genre_ids else {
            return [""]
        }
        var genresArray = [String]()
        
        for numbers in numbers {
            switch numbers {
            case 28:
                genresArray.append("Action")
            case 12:
                genresArray.append("Adventure")
            case 16:
                genresArray.append("Animation")
            case 35:
                genresArray.append("Comedy")
            case 80:
                genresArray.append("Crime")
            case 99:
                genresArray.append("Documentary")
            case 18:
                genresArray.append("Drama")
            case 10751:
                genresArray.append("Family")
            case 14:
                genresArray.append("Fantasy")
            case 36:
                genresArray.append("History")
            case 27:
                genresArray.append("Horror")
            case 10402:
                genresArray.append("Music")
            case 9648:
                genresArray.append("Mystery")
            case 10749:
                genresArray.append("Romance")
            case 878:
                genresArray.append("Science Fiction")
            case 10770:
                genresArray.append("Tv Movie")
            case 53:
                genresArray.append("Thriller")
            case 10752:
                genresArray.append("War")
            case 37:
                genresArray.append("Western")
            default:
                genresArray.append("")
            }
        }
        return genresArray.suffix(2)
    }
}


