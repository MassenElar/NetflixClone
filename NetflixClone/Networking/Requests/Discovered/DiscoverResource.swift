//
//  discoverResource.swift
//  NetflixClone
//
//  Created by developer on 6/16/22.
//

import Foundation


struct DiscoverRecources: AnyResource {
    typealias ModelType = Shows
    
    var url: URL
    
    init() {
        let resourceString = "\(UrlSources.baseUrl)/3/discover/movie?api_key=\(UrlSources.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        guard let resourceUrl = URL(string: resourceString) else {
            fatalError()
        }
        self.url = resourceUrl
    }
}
