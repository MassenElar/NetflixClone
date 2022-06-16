//
//  MovieRequest.swift
//  NetflixClone
//
//  Created by developer on 6/9/22.
//

import Foundation

struct TrendingMoviesRequest {
    func getTrendingMovies(completion: @escaping (Result<[Titles], NetworkError>) -> Void) {
        let request = ModelRequest(resource: TrendingMovieRecources())
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
