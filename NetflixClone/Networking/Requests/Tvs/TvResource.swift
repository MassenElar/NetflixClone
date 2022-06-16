//
//  TvResource.swift
//  NetflixClone
//
//  Created by developer on 6/13/22.
//

import Foundation


struct TrendingTvRecources: AnyResource {
    typealias ModelType = Shows
    
    var url: URL
    
    init() {
        let resourceString = "\(UrlSources.baseUrl)/3/trending/tv/day?api_key=\(UrlSources.API_KEY)"
        guard let resourceUrl = URL(string: resourceString) else {
            fatalError()
        }
        self.url = resourceUrl
    }
}
