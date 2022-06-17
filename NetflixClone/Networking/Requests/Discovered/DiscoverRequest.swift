//
//  discoverRequest.swift
//  NetflixClone
//
//  Created by developer on 6/16/22.
//

import Foundation


struct DiscoverRequest {
    func getDiscover(completion: @escaping (Result<[Titles], NetworkError>) -> Void) {
        let request = ModelRequest(resource: DiscoverRecources())
        request.startRequest { model in
            guard let model = model else {
                completion(.failure(.dataNotFound))
                return
            }
            let movies = model.results
            completion(.success(movies))
        }
    }
}
