//
//  YoutubeResource.swift
//  NetflixClone
//
//  Created by developer on 6/17/22.
//

import Foundation


struct YoutubeRecources: AnyResource {
    typealias ModelType = YoutubeDataModel
    
    var url: URL
    
    init(query: String) {
        let resourceString = "\(Constants.YoutubeBaseUrl)q=\(query)&key=\(Constants.YoutubeAPI_KEY)"
        guard let resourceUrl = URL(string: resourceString) else {
            fatalError()
        }
        self.url = resourceUrl
    }
}
