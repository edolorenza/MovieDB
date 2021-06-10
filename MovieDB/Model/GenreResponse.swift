//
//  GenreResponse.swift
//  MovieDB
//
//  Created by Edo Lorenza on 10/06/21.
//

import Foundation

struct GenreResponse: Codable {
    let genres: [Genre]
}


struct Genre: Codable {
    let id: Int
    let name: String
}

