//
//  MovieResponse.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import Foundation

struct MovieResponse: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Movie]
}

// MARK: - Dates
struct Dates: Codable {
    let maximum: String
    let minimum: String
}

// MARK: - Result
struct Movie: Codable {
    let backdrop_path: String?
    let genre_ids: [Int]?
    let id: Int
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String?
    let release_date: String?
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    //movie detail
    let runtime: Int?
    let genres: [Genre]?
}

