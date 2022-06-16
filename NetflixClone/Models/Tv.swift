//
//  Tv.swift
//  NetflixClone
//
//  Created by developer on 6/13/22.
//

import Foundation



struct TrendingTv: Decodable {
    let results: [Tv]
}

struct Tv: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "original_title"
        case poster = "poster_path"
        case language = "original_language"
        case name = "original_name"
        case overview = "overview"
        case releaseDate = "release_date"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }
    
    let id: Int
    let name: String?
    let title: String?
    let poster: String?
    let language: String?
    let overview: String?
    let releaseDate: String?
    let voteCount: Int
    let voteAverage: Double
    
    
}
