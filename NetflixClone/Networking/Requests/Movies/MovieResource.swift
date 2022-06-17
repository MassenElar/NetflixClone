//
//  MovieResource.swift
//  NetflixClone
//
//  Created by developer on 6/9/22.
//

import Foundation



struct TrendingMovieRecources: AnyResource {
    typealias ModelType = Shows
    
    var url: URL
    
    init() {
        let resourceString = "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.API_KEY)"
        guard let resourceUrl = URL(string: resourceString) else {
            fatalError()
        }
        self.url = resourceUrl
    }
    
}
