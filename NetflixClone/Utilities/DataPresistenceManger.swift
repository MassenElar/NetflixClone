//
//  DataPresistenceManger.swift
//  NetflixClone
//
//  Created by developer on 6/20/22.
//

import Foundation
import UIKit
import CoreData


class DataPresistenceManger {
    
    enum DataPresistensceError: Error {
        case failedToSaveData
        case failedFetchingData
        case failedToDelete
    }
    
    static let shared = DataPresistenceManger()
    
    func downloadShow(with model: Titles, completion: @escaping (Result<Void, DataPresistensceError>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = ShowItem(context: context)
        
        item.id = Int64(model.id)
        item.title = model.title
        item.name = model.name
        item.overview = model.overview
        item.language = model.language
        item.poster = model.poster
        item.releaseDate = model.releaseDate
        item.voteAverage = model.voteAverage
        item.voteCount = Int64(model.voteCount)
        
        do {
            try context.save()
            completion(.success(()))
        }catch {
            completion(.failure(DataPresistensceError.failedToSaveData))
        }
    }
    
    func fetchData(completion: @escaping (Result<[ShowItem], DataPresistensceError>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        let context = appDelegate.persistentContainer.viewContext
        
        let req: NSFetchRequest<ShowItem>
        
        req = ShowItem.fetchRequest()
        
        do {
            
            let shows = try context.fetch(req)
            completion(.success(shows))
            
        }catch {
            completion(.failure(DataPresistensceError.failedFetchingData))
        }
    }
    
    
    func deletingItem(with model: ShowItem, completion: @escaping(Result<Void, DataPresistensceError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataPresistensceError.failedToDelete))
        }
    }
}
