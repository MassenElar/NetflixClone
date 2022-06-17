//
//  TopRatedResource.swift
//  NetflixClone
//
//  Created by developer on 6/14/22.
//

import Foundation


struct TopRatedRecources: AnyResource {
    typealias ModelType = Shows
    
    var url: URL
    
    init() {
        let resourceString = "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        guard let resourceUrl = URL(string: resourceString) else {
            fatalError()
        }
        self.url = resourceUrl
    }
}
