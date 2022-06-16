//
//  TvRequest.swift
//  NetflixClone
//
//  Created by developer on 6/13/22.
//

import Foundation

struct TrendingTvsRequest {
    func getTrendingTvs(completion: @escaping (Result<[Titles], NetworkError>) -> Void) {
        let request = ModelRequest(resource: TrendingTvRecources())
        request.startRequest { model in
            guard let model = model else {
                completion(.failure(.dataNotFound))
                return
            }
            let tvs = model.results
            completion(.success(tvs))
        }
    }
}
