//
//  AnyRecource.swift
//  NetflixClone
//
//  Created by developer on 6/10/22.
//

import Foundation

protocol AnyResource {
    associatedtype ModelType: Decodable
    var url: URL { get }
}
