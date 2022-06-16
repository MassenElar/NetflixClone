//
//  NetrworkRequestErrors.swift
//  NetflixClone
//
//  Created by developer on 6/10/22.
//

import Foundation


enum NetworkError: Error {
    case dataNotFound
    case cannotDecodeData
    case serverError
    case unautorized 
}
