//
//  UpcomingRequest.swift
//  NetflixClone
//
//  Created by developer on 6/13/22.
//

import Foundation


struct UpcomingRequest {
    func getUpcomingMovie(completion: @escaping (Result<[Titles], NetworkError>) -> Void) {
        let request = ModelRequest(resource: UpcomingRecources())
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
