//
//  SearchResource.swift
//  NetflixClone
//
//  Created by developer on 6/16/22.
//

import Foundation

//https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=Jack+Reacher

struct SearchRecources: AnyResource {
    typealias ModelType = Shows
    
    var url: URL
    
    init(query: String) {
        let resourceString = "\(UrlSources.baseUrl)/3/search/movie?api_key=\(UrlSources.API_KEY)&query=\(query)"
        guard let resourceUrl = URL(string: resourceString) else {
            fatalError()
        }
        self.url = resourceUrl
    }
}
