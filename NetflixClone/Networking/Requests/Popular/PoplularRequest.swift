//
//  PoplularRequest.swift
//  NetflixClone
//
//  Created by developer on 6/14/22.
//

import Foundation



struct PopularRequest {
    func getPopularMovie(completion: @escaping (Result<[Titles], NetworkError>) -> Void) {
        let request = ModelRequest(resource: PopularRecources())
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
