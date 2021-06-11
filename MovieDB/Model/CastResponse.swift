//
//  CastResponse.swift
//  MovieDB
//
//  Created by Edo Lorenza on 11/06/21.
//

import Foundation

struct CastResponse: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Cast]
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool
    let gender: Int
    let id: Int
    let known_for_department: String
    let name: String
    let original_name: String
    let popularity: Double
    let profile_path: String?
    let cast_id: Int?
    let character: String?
    let credit_id: String
    let order: Int?
    let department, job: String?
}
