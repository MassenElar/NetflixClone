//
//  Tv.swift
//  NetflixClone
//
//  Created by developer on 6/13/22.
//

import Foundation



struct YoutubeDataModel: Decodable {
    let items: [Video]
}

struct Video: Decodable {
    let id: videoDetails
}

struct videoDetails: Decodable {
    let kind: String?
    let videoId: String?
}
