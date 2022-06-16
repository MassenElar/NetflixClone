//
//  TopRatedRequest.swift
//  NetflixClone
//
//  Created by developer on 6/14/22.
//

import Foundation


struct TopRatedRequest {
    func getTopRatedMovie(completion: @escaping (Result<[Titles], NetworkError>) -> Void) {
        let request = ModelRequest(resource: TopRatedRecources())
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
