//
//  YoutubeRequest.swift
//  NetflixClone
//
//  Created by developer on 6/17/22.
//

import Foundation


struct YoutubeRequest {
    func getYoutubeResult(with query: String, completion: @escaping (Result<[Video], NetworkError>) -> Void) {
        guard let keyword = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let request = ModelRequest(resource: YoutubeRecources(query: keyword))
        request.startRequest { model in
            guard let model = model else {
                completion(.failure(.dataNotFound))
                return
            }
            let res = model.items
            completion(.success(res))
        }
    }
}
