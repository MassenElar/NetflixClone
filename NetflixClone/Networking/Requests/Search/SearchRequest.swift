//
//  SearchRequest.swift
//  NetflixClone
//
//  Created by developer on 6/16/22.
//

import Foundation


struct SearchRequest {
    func getSearchResult(with query: String, completion: @escaping (Result<[Titles], NetworkError>) -> Void) {
        guard let keyword = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let request = ModelRequest(resource: SearchRecources(query: keyword))
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
