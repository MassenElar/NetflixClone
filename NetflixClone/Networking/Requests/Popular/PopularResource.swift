//
//  PopularResource.swift
//  NetflixClone
//
//  Created by developer on 6/14/22.
//

import Foundation


struct PopularRecources: AnyResource {
    typealias ModelType = Shows
    
    var url: URL
    
    init() {
        let resourceString = "\(UrlSources.baseUrl)/3/movie/popular?api_key=\(UrlSources.API_KEY)&language=en-US&page=1"
        guard let resourceUrl = URL(string: resourceString) else {
            fatalError()
        }
        self.url = resourceUrl
    }
}
